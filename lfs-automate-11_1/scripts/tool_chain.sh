source $LFS/scripts/su_env_vars.sh

while IFS=';' read -r chapter name package folder; do
	printf '=%.0s' {1..70}; echo
	echo ${chapter/_/\.}. $name
	printf '*%.0s' {1..70}; echo

	chapter=ch$chapter

	cd $LFS/build
	rm -rf *
	tar xf $LFS/sources/$package
	cd $folder

	log_file=$LFS/build_log/${chapter}-`date +%Y%m%d_%H%M%S`.log
	touch $log_file
	ln -fs $log_file $LFS/build_log/lastlog

	SECONDS=0

	source $LFS/scripts/$stage/$chapter.sh &> $log_file

	gzip $log_file
	echo 'OK. See the log file by the following command:'
	echo "gzip -cd $log_file.gz"
	echo

	df -h $LFS	

	grep -E 'MemFree|SwapCached' /proc/meminfo

	printf 'Time elapsed: '
	date -d@$SECONDS -u +%H:%M:%S

done < "$LFS/scripts/$stage.csv"

rm -rf $LFS/build/*
