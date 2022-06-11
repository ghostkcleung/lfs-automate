source scripts/vr_kern_fs.sh # Chapter 7.3

if chroot "$LFS" /usr/bin/env -i stage=$stage PS1='(lfs chroot) \u:\w\$ ' \
	/bin/bash --login /scripts/chroot_env.sh; then

	cp -R copy_files $LFS

	chroot "$LFS" /usr/bin/env -i stage=$stage PS1='(lfs chroot) \u:\w\$ ' \
		/bin/bash --login /scripts/stage6a.sh

	pushd $LFS &> /dev/null
	umount -R $LFS &> /dev/null || true
	popd &> /dev/null

	if [ $KEEP_STAGE_TAR != 'YES' ]; then
		rm stage*.tar &> /dev/null || true
	fi

	printf '=%.0s' {1..70}; echo
	echo "Creating backup file '$LFS_HOSTNAME-non_uefi.tar'..."

	tar cf $LFS_HOSTNAME-non_uefi.tar --exclude sources --exclude scripts -C $LFS .
	chown $SUDO_USER $LFS_HOSTNAME-non_uefi.tar
else
	tail -n10 $LFS/build_log/lastlog
	echo 'Error. See the log file by the following command:'
	echo "cat `readlink $LFS/build_log/lastlog`"
	false
fi
