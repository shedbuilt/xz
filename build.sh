#!/bin/bash
case "$SHED_BUILD_MODE" in
    toolchain)
        ./configure --prefix=/tools || return 1
        ;;
    *)
        ./configure --prefix=/usr    \
                    --disable-static \
                    --docdir=/usr/share/doc/xz-5.2.3 || return 1
        ;;
esac
make -j $SHED_NUM_JOBS || return 1
make DESTDIR="$SHED_FAKE_ROOT" install || return 1

# Rearrange binaries
if [ "$SHED_BUILD_MODE" != 'toolchain' ]; then
    mkdir -v "${SHED_FAKE_ROOT}/bin"
    mv -v ${SHED_FAKE_ROOT}/usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} "${SHED_FAKE_ROOT}/bin"
    mkdir -v "${SHED_FAKE_ROOT}/lib"
    mv -v ${SHED_FAKE_ROOT}/usr/lib/liblzma.so.* "${SHED_FAKE_ROOT}/lib"
    ln -svf ../../lib/$(readlink ${SHED_FAKE_ROOT}/usr/lib/liblzma.so) "${SHED_FAKE_ROOT}/usr/lib/liblzma.so"
fi
