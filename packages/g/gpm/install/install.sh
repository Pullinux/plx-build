install -m 644 gpm.service /usr/lib/systemd/system/
install -m 644 gpm.path    /usr/lib/systemd/system/
systemctl enable gpm.service
