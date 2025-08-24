
useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp || true
groupadd -g 19 lpadmin || true

ln -svnf ../cups/doc-2.4.11 /usr/share/doc/cups-2.4.11
echo "ServerName /run/cups/cups.sock" > /etc/cups/client.conf

cat > /etc/pam.d/cups << "EOF"
# Begin /etc/pam.d/cups

auth    include system-auth
account include system-account
session include system-session

# End /etc/pam.d/cups
EOF

systemctl enable cups
