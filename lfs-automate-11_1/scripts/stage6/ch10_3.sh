pushd /build &> /dev/null || true

tar xf /sources/linux-5.16.9.tar.xz
cd linux-5.16.9

make mrproper
make defconfig

make &> /dev/null
make modules_install &> /dev/null

cp -iv arch/x86/boot/bzImage /boot/vmlinuz-5.16.9-lfs-11.1
cp -iv System.map /boot/System.map-5.16.9
cp -iv .config /boot/config-5.16.9

install -d /usr/share/doc/linux-5.16.9
cp -r Documentation/* /usr/share/doc/linux-5.16.9

popd &> /dev/null || true
