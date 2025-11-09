export www_uid=$(id -u www-data)
export www_gid=$(id -g www-data)

incus init oci-docker:actualbudget/actual-server ActualBudget

incus storage volume create default ActualBudgetData
incus storage volume attach default ActualBudgetData ActualBudget /data

incus config device add ActualBudget http_proxy proxy listen=unix:/tmp/actualbudget.socket connect=tcp:127.0.0.1:5006 bind=host uid=$www_uid gid=$www_gid