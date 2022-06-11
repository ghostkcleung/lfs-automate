chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
	x86_64) chown -R root:root $LFS/lib64 ;;
esac

source scripts/vr_kern_fs.sh # Chapter 7.3

chroot "$LFS" /usr/bin/env -i		\
	HOME=/root			\
	TERM="$TERM"			\
	PS1='(lfs chroot) \u:\w\$ '	\
	PATH=/usr/bin:/usr/sbin		\
	/bin/bash --login /scripts/ch7_5.sh


if chroot "$LFS" /usr/bin/env -i stage=$stage PS1='(lfs chroot) \u:\w\$ ' \
	/bin/bash --login /scripts/chroot_env.sh; then

	chroot "$LFS" /usr/bin/env -i PS1='(lfs chroot) \u:\w\$ ' \
		/bin/bash --login /scripts/ch7_14.sh

	pushd $LFS &> /dev/null
	umount -R $LFS &> /dev/null || true
	popd &> /dev/null

	if [ $KEEP_STAGE_TAR != 'YES' ]; then
		rm stage*.tar &> /dev/null || true
	fi

	printf '=%.0s' {1..70}; echo
	echo "Creating backup file '$stage.tar'..."

	tar cf $stage.tar --exclude sources --exclude scripts -C $LFS .
	chown $SUDO_USER $stage.tar
else
	tail -n10 $LFS/build_log/lastlog
	echo 'Error. See the log file by the following command:'
	echo "cat `readlink $LFS/build_log/lastlog`"
	false
fi

stage_num=$(( ${stage//[^0-9]/} + 1 ))
stage=${stage/[0-9]/$stage_num}
source scripts/$stage.sh
