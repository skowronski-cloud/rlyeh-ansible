echo "[Resolve]\nDNS=1.1.1.1" > /etc/systemd/resolved.conf
systemctl restart systemd-resolved

/usr/sbin/sysctl -w net.ipv6.conf.all.disable_ipv6=1

/usr/bin/apt -y install openssh-server

/bin/mkdir -p /root/.ssh
/bin/chmod 0700 /root/.ssh
/bin/echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICVjha8GTL5ZQQeno3X7/21lmE2CMgvT855zFUwhszcW YGGDRASIL" >> /root/.ssh/authorized_keys
/bin/chmod 0600 /root/.ssh/authorized_keys
