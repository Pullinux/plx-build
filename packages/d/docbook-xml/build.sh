
install -v -d -m755 $PCKDIR/usr/share/xml/docbook/xml-dtd-4.5 
install -v -d -m755 $PCKDIR/etc/xml 
cp -v -af --no-preserve=ownership docbook.cat *.dtd ent/ *.mod \
    $PCKDIR/usr/share/xml/docbook/xml-dtd-4.5
