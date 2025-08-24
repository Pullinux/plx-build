ldconfig                             &&
update-mime-database /usr/share/mime &&
xdg-icon-resource forceupdate        &&
update-desktop-database -q

mkdir -p /etc/skel/.config

cp -r lxqt /etc/skel/.config/
