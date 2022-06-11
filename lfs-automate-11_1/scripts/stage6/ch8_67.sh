./configure --prefix=/usr

sed -e 's/__attribute_nonnull__/__nonnull/' \
    -i gnulib/lib/malloc/dynarray-skeleton.c

make

make install

make TEXMF=/usr/share/texmf install-tex
