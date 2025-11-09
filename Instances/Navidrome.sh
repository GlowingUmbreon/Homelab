export www_uid=$(id -u www-data)
export www_gid=$(id -g www-data)

incus remote add oci-docker https://docker.io --protocol=oci
incus init oci-docker:deluan/navidrome Navidrome

incus storage volume create default NavidromeMusic
incus storage volume attach default NavidromeMusic Navidrome /music
incus storage volume create default NavidromeData
incus storage volume attach default NavidromeData Navidrome /data

incus config set Navidrome environment.ND_ADDRESS unix:/tmp/navidrome.socket
incus config set Navidrome environment.ND_ENABLEINSIGHTSCOLLECTOR false
incus config set Navidrome environment.ND_DEFAULTTHEME Nuclear

incus config device add Navidrome http_proxy proxy listen=unix:/tmp/navidrome.socket connect=unix:/tmp/navidrome.socket bind=host uid=$www_uid gid=$www_gid