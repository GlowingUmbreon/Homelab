# Nginx
apt update
apt install nginx

systemctl enable nginx --now

# Incus - Install Zabbly Repo's - https://github.com/zabbly/incus
curl -fsSL https://pkgs.zabbly.com/key.asc | gpg --show-keys --fingerprint
mkdir -p /etc/apt/keyrings/
curl -fsSL https://pkgs.zabbly.com/key.asc -o /etc/apt/keyrings/zabbly.asc

sh -c 'cat <<EOF > /etc/apt/sources.list.d/zabbly-incus-stable.sources
Enabled: yes
Types: deb
URIs: https://pkgs.zabbly.com/incus/stable
Suites: $(. /etc/os-release && echo ${VERSION_CODENAME})
Components: main
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/zabbly.asc

EOF'

apt update
apt install incus incus-ui-canonical
systemctl enable incus --now

# Incus - Init
incus admin init --auto
incus config set core.https_address :8443
# TODO: Setup drives etc. Here

# Incus - Navidrome Container
incus remote add oci-docker https://docker.io --protocol=oci
incus init oci-docker:deluan/navidrome Navidrome

incus storage volume create default NavidromeMusic
incus storage volume attach default NavidromeMusic Navidrome /music
incus storage volume create default NavidromeData
incus storage volume attach default NavidromeData Navidrome /data

incus config set Navidrome environment.ND_ADDRESS unix:/tmp/navidrome.socket
incus config set Navidrome environment.ND_ENABLEINSIGHTSCOLLECTOR false
incus config set Navidrome environment.ND_DEFAULTTHEME Nuclear

incus config device add Navidrome http_proxy proxy listen=unix:/tmp/navidrome.socket connect=unix:/tmp/navidrome.socket bind=host mode=0777
# TODO: Remove mode=0777 above, instead adjust the owner to www-data
# the id -u www-data command should get the user's id -g for group