# Nginx
apt update
apt install nginx

systemctl enable nginx --now

# Certbot
# apt install certbot
# certbot certonly --webroot --webroot-path /opt/webroot/ -d REDACT

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