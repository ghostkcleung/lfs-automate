mkdir -p $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -fs usr/$i $LFS &> /dev/null || true
done

case $(uname -m) in
  x86_64) mkdir -p $LFS/lib64 ;;
esac

mkdir -p $LFS/tools

chown lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown lfs $LFS/lib64 ;;
esac

mv /etc/bash.bashrc /etc/bash.bashrc.NOUSE &> /dev/null || true
if su - $LFS_USER -c "env -i LFS=$LFS stage=$stage bash $LFS/scripts/tool_chain.sh"; then
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
mv /etc/bash.bashrc.NOUSE /etc/bash.bashrc &> /dev/null || true

stage_num=$(( ${stage//[^0-9]/} + 1 ))
stage=${stage/[0-9]/$stage_num}
source scripts/$stage.sh
