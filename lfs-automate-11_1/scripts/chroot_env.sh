set -e

source /scripts/chroot_env_vars.sh

while IFS=';' read -r chapter name package folder; do
	printf '=%.0s' {1..70}; echo
	echo ${chapter/_/\.}. $name
	printf '*%.0s' {1..70}; echo

	chapter=ch$chapter

	cd /build
	rm -rf *
	tar xf /sources/$package
	cd $folder

	log_file=/build_log/${chapter}-`date +%Y%m%d_%H%M%S`.log
	touch $log_file
	ln -fs $LFS$log_file /build_log/lastlog

	SECONDS=0

	source /scripts/$stage/$chapter.sh &> $log_file

	gzip $log_file
	echo 'OK. See the log file by the following command:'
	echo "gzip -cd $LFS$log_file.gz"
	echo

	df -h /

	grep -E 'MemFree|SwapCached' /proc/meminfo

	printf 'Time elapsed: '
	date -d@$SECONDS -u +%H:%M:%S

done < "/scripts/$stage.csv"

rm -rf /build/*
