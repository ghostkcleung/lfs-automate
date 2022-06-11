pushd /build &> /dev/null || true
	tar xf /sources/lfs-bootscripts-20210608.tar.xz
	cd lfs-bootscripts-20210608
	make install
popd &> /dev/null || true

bash /usr/lib/udev/init-net-rules.sh
