groupadd -fg 84 avahi || true
useradd -c "Avahi Daemon Owner" -d /run/avahi-daemon -u 84 \
        -g avahi -s /bin/false avahi || true
groupadd -fg 86 netdev || true

systemctl enable avahi-daemon
systemctl enable avahi-dnsconfd
