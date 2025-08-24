sed -i '/calver/s/^/#/;$iversion="2025.1.15.22"' setup.py

pip3 wheel -w $PCKDIR/.install/dist --no-build-isolation --no-deps --no-cache-dir $PWD