#!/bin/bash
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.2.3
make -j $SHED_NUMJOBS
make DESTDIR=${SHED_FAKEROOT} install
mkdir -v ${SHED_FAKEROOT}/bin
mv -v   ${SHED_FAKEROOT}/usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} ${SHED_FAKEROOT}/bin
mkdir -v ${SHED_FAKEROOT}/lib
mv -v ${SHED_FAKEROOT}/usr/lib/liblzma.so.* ${SHED_FAKEROOT}/lib
ln -svf ../../lib/$(readlink ${SHED_FAKEROOT}/usr/lib/liblzma.so) ${SHED_FAKEROOT}/usr/lib/liblzma.so
