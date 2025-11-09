apt update
apt install restic

#/etc/systemd/system/restic_backup@.service;
#Description=Restic Backup - %i
#Wants=network.target
#After=network.target
#
#[Timer]
#OnCalendar=*-*-* 02:00:00
#
#[Service]
#User=root
#ExecStart=incus exec %i -- apt-get update
#Type=oneshot

