./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.2.1

make
make html

make check 2>&1 | tee gmp-check-log || true

if [[ `awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log` != 197 ]]; then
	awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
	false
fi

make install
make install-html
