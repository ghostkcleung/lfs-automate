set +e
source /scripts/chroot_env_vars.sh

echo '8.77. Stripping'
source /scripts/stage6/ch8_77.sh &> /dev/null

echo '8.78. Cleaning Up'
source /scripts/stage6/ch8_78.sh &> /dev/null

echo '9.2. LFS-Bootscripts-20210608'
source /scripts/stage6/ch8_92.sh &> /dev/null

bash /usr/lib/udev/init-net-rules.sh # Chapter 9.4

touch /etc/sysconfig/console

install --directory --mode=0755 --owner=root --group=root /etc/profile.d
install --directory --mode=0755 --owner=root --group=root /etc/bash_completion.d
install --directory --mode=0755 --owner=root --group=root /etc/skel

install -v -m755 -d /etc/modprobe.d

chmod +x /copy_files/usr/sbin/*
cp -Ru /copy_files/* /
rm -rf /copy_files

echo $LFS_HOSTNAME > /etc/hostname

cat > /etc/profile.d/i18n.sh << "EOF"
# Set up i18n variables
export LANG=$LFS_LANG
EOF

echo 'Fixing Locale Related Issues (BLFS Chapter 2)' 
find /usr/share/man -type f | xargs /usr/sbin/checkman.sh &> /dev/null
dircolors -p > /etc/dircolors

echo 'Random Number Generation (BLFS Chapter 3)'
pushd /build &> /dev/null || true
tar xf /sources/blfs-bootscripts-20210826.tar.xz
cd blfs-bootscripts-20210826

make install-random
popd &> /dev/null || true

if [[ $BUILD_DEFAULT_KERNEL == 'YES' && $WITH_UEFI != 'YES' ]]; then
	echo '10.3. Linux-5.16.9'
	source /scripts/stage6/ch10_3.sh
fi

rm -rf /build/*
