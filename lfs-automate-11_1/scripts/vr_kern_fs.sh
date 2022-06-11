mkdir -p $LFS/{dev,proc,sys,run}

mknod -m 600 $LFS/dev/console c 5 1 &> /dev/null || true
mknod -m 666 $LFS/dev/null c 1 3 &> /dev/null || true

pushd $LFS &> /dev/null
umount -R $LFS &> /dev/null || true
popd &> /dev/null

mount --bind sources $LFS/sources

mount --bind /dev $LFS/dev

mount --bind /dev/pts $LFS/dev/pts
mount -t proc proc $LFS/proc
mount -t sysfs sysfs $LFS/sys
mount -t tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -p $LFS/$(readlink $LFS/dev/shm)
fi
