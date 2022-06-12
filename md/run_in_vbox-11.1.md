# Run in Virtual Box (LFS 11.1)
Add the current user to the 'disk' group. You need to logout to update groups.
``` bash
sudo usermod -aG disk `users`
groups # Check the groups
```

Prepare the lfs environment.
``` bash
LFS=/mnt/lfs
fallocate -l 3G lfs-automate-11_1.img # Create a dummy image

LO_DEV=`losetup -fP --show lfs-automate-11_1.img` # Create a loop device
echo $LO_DEV # The --show option will tell you which loop device you are created

sudo fdisk $LO_DEV
####### We only need 1 parimary partition like this #######
# Device        Boot Start     End Sectors Size Id Type   #
# /dev/loop<X>p1       2048 6291455 6289408   3G 83 Linux  #
###########################################################

sudo mkfs.ext4 ${LO_DEV}p1

sudo mount ${LO_DEV}p1 $LFS # mount the partition $LFS

sudo tar xf lfs-automate-11_1.tar -C $LFS # Restore the tar archive.
```
Mount the virtual kernel file system and enter the chroot environment
``` bash
pushd $LFS
sudo umount -R $LFS
popd

sudo mount -v --bind /dev $LFS/dev

sudo mount -v --bind /dev/pts $LFS/dev/pts
sudo mount -vt proc proc $LFS/proc
sudo mount -vt sysfs sysfs $LFS/sys
sudo mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  sudo mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

sudo chroot "$LFS" /usr/bin/env -i   \
    LO_DEV=$LO_DEV /bin/bash --login
```
Install grub to the loop device
``` bash
grub-install $LO_DEV --target=i386-pc
```
Create the 'fstab' file
``` bash
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order
/dev/sda1     /            <fff>    defaults            1     1

proc           /proc        proc     nosuid,noexec,nodev 0     0
sysfs          /sys         sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts     devpts   gid=5,mode=620      0     0
tmpfs          /run         tmpfs    defaults            0     0
devtmpfs       /dev         devtmpfs mode=0755,nosuid    0     0

# End /etc/fstab
EOF
```
Create the 'grub.cfg' file
``` bash
cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd0,msdos1)

menuentry "GNU/Linux, Linux 5.16.9-lfs-11.1" {
        linux   /boot/vmlinuz-5.16.9-lfs-11.1 root=/dev/sda1 ro
}
EOF
```
Unmount, unbind and detach
``` bash
exit    # Back to the normal shell

sudo umount -R $LFS
losetup -d $LO_DEV
```
Create the vmdk file
``` bash
vboxmanage internalcommands createrawvmdk \
  -filename lfs-automate-11_1.vmdk \
  -rawdisk lfs-automate-11_1.img
```
