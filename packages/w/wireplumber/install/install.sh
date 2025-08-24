rm -vf /etc/xdg/autostart/pulseaudio.desktop         
rm -vf /etc/xdg/Xwayland-session.d/00-pulseaudio-x11 
sed -e '$a autospawn = no' -i /etc/pulse/client.conf

systemctl enable --global pipewire.socket       
systemctl enable --global pipewire-pulse.socket 
systemctl enable --global wireplumber
