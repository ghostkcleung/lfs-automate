LFS=/mnt/lfs		# See chapter 2.6
LFS_USER=lfs		# User for tool-chain. no need to change it. 
LFS_GROUP=lfs		# Group for tool-chain. no need to change it.

# Parallel make. See chapter 4.5
MAKEFLAGS=-j`grep -c ^processor /proc/cpuinfo`

# Timezone. See chapter 8.5
TZ=`readlink /etc/localtime`
TZ=${TZ/\/usr\/share\/zoneinfo\//}

# 'letter' for users in the United States
# 'A4' for non US
GROFF_PAGESIZE='A4'

KEEP_STAGE_TAR=NO			# YES for keep the old stageX.tar after the new stage is built. non-YES is recommand.
LFS_HOSTNAME='lfs-automate-11_1'	# Name of the new host

BUILD_DEFAULT_KERNEL=YES		# Build kernel with default config
WITH_UEFI=NO	# UEFI, YES or ( non-YES )
