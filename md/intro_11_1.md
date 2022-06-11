# Introduction for build LFS 11.1 with automate script.

## Before start
Firstly, I hope you can "Fully Read" the LFS book https://www.linuxfromscratch.org to understand what are you doing.
The scripts is just for assist you to skip a lot of copy and paste jobs.

## Requirements
The script uses up to 6GB RAM disk to build that is mount as tmpfs. So it will use the swap cache if the memory is not enough and the processing will be slowed down.
Run the version-check.sh for the requirment. ( See chapter 2.2 )

https://www.linuxfromscratch.org/lfs/view/11.1/chapter02/hostreqs.html
## Start to build

Run the following command to start:
``` bash
sudo bash build.sh
```

Read the text carefully, then enter 'Y' to continoue.
```
Automate script for LFS 11.1
**********************************************************************
Please check before start...
1. Run the 'version-check.sh' for the requirements. (See chapter 2.2)
2. The script need to run as root: root
**********************************************************************
BE ATTENTION!!! BE ATTENTION!!! BE ATTENTION!!!
**********************************************************************
The scripts may take more than few hours.
It takes up to about 6GB memories(tmpfs).
You cannot stop it by pressing [Ctrl-c].
If you need to terminate really. Reboot the host system forcibly.
**********************************************************************
Enter 'Y' to continue or 'N' to exit: 
```
Finally, the tar file 'lfs-automate-11_1*.tar' will be created if there no error.
The size is about 1.2GB without kernel.

- **You should not press the [CTRL-C] to stop during the processing.**
- **You should not press the [CTRL-C] to stop during the processing.**
- **You should not press the [CTRL-C] to stop during the processing.**

It is important.

## If error when build.
- See the log file to the the reason.
- Rename '/etc/bash.bashrc.NOUSE' to '/etc/bash.bashrc.NOUSE'.
- Delete the 'lfs' user.
- Unmount the LFS point.
``` bash
sudo mv /etc/bash.bashrc.NOUSE /etc/bash.bashrc
sudo userdel -rf lfs
sudo umount -R /mnt/lfs
```

## Entering the chroot environment
See the chapter 7.3, 7.4
https://www.linuxfromscratch.org/lfs/view/stable/chapter07/kernfs.html

- Umount all the virtual kernel file system to prevent double mount.
- Remount virtual kernel file system. And bind the source code also.
- Enter chroot
``` bash
pushd $LFS
umount -R $LFS # It's OK if you can see 'umount: /mnt/lfs: not mounted'.
popd

mount -v --bind /dev $LFS/dev

mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

mount -v --bind sources $LFS/sources

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

sudo chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    /bin/bash --login
```
