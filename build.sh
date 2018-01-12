#!/bin/bash
case "$SHED_BUILDMODE" in
    toolchain)
        ./configure --prefix=/tools || return 1
        ;;
    *)
        ./configure --prefix=/usr    \
                    --disable-static \
                    --docdir=/usr/share/doc/xz-5.2.3 || return 1
        ;;
esac
make -j $SHED_NUMJOBS || return 1
make DESTDIR="$SHED_FAKEROOT" install || return 1

# Rearrange binaries
if [ "$SHED_BUILDMODE" != 'toolchain' ]; then
    mkdir -v "${SHED_FAKEROOT}/bin"
    mv -v ${SHED_FAKEROOT}/usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} "${SHED_FAKEROOT}/bin"
    mkdir -v "${SHED_FAKEROOT}/lib"
    mv -v ${SHED_FAKEROOT}/usr/lib/liblzma.so.* "${SHED_FAKEROOT}/lib"
    ln -svf ../../lib/$(readlink ${SHED_FAKEROOT}/usr/lib/liblzma.so) "${SHED_FAKEROOT}/usr/lib/liblzma.so"
fi
