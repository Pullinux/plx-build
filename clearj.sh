sudo systemctl stop systemd-journald && sudo rm -rf /var/log/journal/* /run/log/journal/* && sudo systemctl start systemd-journald
