# Run in Virtual Box (LFS 11.1)
Add the current user to the 'disk' group. You need to logout to update groups.
``` bash
sudo usermod -aG disk `users`
groups # Check the groups
```

Create a dummy image file
``` bash
fallocate -l 3G lfs-automate-11_1.img
```
