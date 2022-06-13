printf '=%.0s' {1..70}; echo
echo Automate script for LFS 11.1
printf '*%.0s' {1..70}; echo
echo Please check before start...

echo "1. Run the 'version-check.sh' for the requirements. (See chapter 2.2)"

printf '2. The script need to run as root: '; id -u -n
((`id -u` == 0))

printf '*%.0s' {1..70}; echo
echo 'BE ATTENTION!!! BE ATTENTION!!! BE ATTENTION!!!'
printf '*%.0s' {1..70}; echo

cat << EOF
The scripts may take more than few hours.
It takes up to about 7GB memories(tmpfs).
You cannot stop it by pressing [Ctrl-c].
If you need to terminate really. Reboot the host system forcibly.
EOF

printf '*%.0s' {1..70}; echo

while [[ $answer != 'y' ]]; do
	read -p "Enter 'Y' to continue or 'N' to exit: " answer
	answer=${answer,,}

	if [[ $answer == 'n' ]]; then
		echo Good bye
		false
	fi
done
