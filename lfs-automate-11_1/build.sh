set -e

source settings.sh
source promt.sh

mkdir -p $LFS
umount -R $LFS &> /dev/null || true	# Make sure all lfs related point is not mounted.

mount -t tmpfs -0 size=7G tmpfs $LFS

cp -R scripts $LFS

if [[ ! -f $LFS_HOSTNAME.tar ]]; then

################ Chapter 4.3 ####################
userdel -rf $LFS_USER &> /dev/null || true

groupadd -f $LFS_GROUP
useradd -s /bin/bash -g $LFS_GROUP -m -k /dev/null $LFS_USER
########## End of chapter 4.3 ####################

	pushd sources > /dev/null
		md5sum -c md5sums > /dev/null
	popd > /dev/null

	mkdir -p $LFS/sources
	mount --bind sources $LFS/sources
	
	mkdir -p $LFS/build
	mkdir -p $LFS/build_log

	chown lfs $LFS/build
	chown lfs $LFS/build_log

################ Chapter 4.2 ####################
cat << EOF > $LFS/scripts/su_env_vars.sh
set -e
set +h
umask 022

export LFS=$LFS
export TERM=$TERM
export MAKEFLAGS=$MAKEFLAGS

export LC_ALL=POSIX

export LFS_TGT=$(uname -m)-lfs-linux-gnu
export CONFIG_SITE=$LFS/usr/share/config.site
EOF

LFS_PATH=/usr/bin

if [ ! -L /bin ]; then LFS_PATH=/bin:$LFS_PATH; fi
LFS_PATH=$LFS/tools/bin:$LFS_PATH

echo "export PATH=$LFS_PATH" >> $LFS/scripts/su_env_vars.sh

LFS_HOME=`su - $LFS_USER -c pwd`
echo "export HOME=$LFS_HOME" >> $LFS/scripts/su_env_vars.sh
############# End of chapter 4.2 ################

################ Chapter 7.2 ####################
cat << EOF > $LFS/scripts/chroot_env_vars.sh
export LFS=$LFS
export HOME=/root
export TERM=$TERM
export PATH=/usr/bin:/usr/sbin
export MAKEFLAGS=$MAKEFLAGS
export TZ=$TZ
export GROFF_PAGESIZE=$GROFF_PAGESIZE
export LFS_HOSTNAME=$LFS_HOSTNAME
export LFS_LANG=$LANG
export BUILD_DEFAULT_KERNEL=$BUILD_DEFAULT_KERNEL
EOF
############# End of chapter 7.2 ################

	for i in {5..0}; do
		tar_name=stage$i.tar
		stage=stage$(( i+1 ))

		if [ $i = 0 ]; then
			source scripts/stage1.sh
			break
		fi


		if [[ -f $tar_name ]]; then
			echo "The backup file '$tar_name' is found. Recovering..."
			tar xf $tar_name -C $LFS

			source scripts/$stage.sh
			break
		fi
	done
fi

if [[ $WITH_UEFI = 'YES' && ! -f $LFS_HOSTNAME-uefi.tar ]]; then
	true
fi

cat << EOF
Congratulations! All source code has been built.
Next, read the chapter 10 to making the LFS system bootable.
https://www.linuxfromscratch.org/lfs/view/stable/chapter10/chapter10.html
Good luck.
EOF

mv /etc/bash.bashrc.NOUSE /etc/bash.bashrc &> /dev/null || true
userdel -rf $LFS_USER &> /dev/null || true
umount -R $LFS
