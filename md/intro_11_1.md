# Introduction for build LFS 11.1 with automate script.

## Requirements
The script uses up to 6GB RAM disk to build that is mount as tmpfs. So it will use the swap cache if the memory is not enough and the processing will be slowed down. Finally, the tar file 'lfs-automate-11_1*.tar' will be created. It is about 1.2GB without kernel.

Run the version-check.sh for the requirment.

## Start to build

Run the following command to start:
``` bash
sudo bash build.sh
```
