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

sudo fdisk $LO_DEV # We only need 1 parimary partition

sudo mount ${LO_DEV}p1 $LFS # mount the partition $LFS
tar xf lfs-automate-11_1.tar $LFS # Restore the tar archive.

```
