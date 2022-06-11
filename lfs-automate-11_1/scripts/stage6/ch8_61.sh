sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

make

make SBINDIR=/usr/sbin install

mkdir -pv             /usr/share/doc/iproute2-5.16.0
cp -v COPYING README* /usr/share/doc/iproute2-5.16.0
