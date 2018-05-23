#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
SHED_PKG_LOCAL_PREFIX='/usr'
SHED_PKG_LOCAL_STATIC_OPTION='--disable-static'
if [ -n "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
    SHED_PKG_LOCAL_PREFIX='/tools'
    SHED_PKG_LOCAL_STATIC_OPTION=''
fi
SHED_PKG_LOCAL_DOCDIR=${SHED_PKG_LOCAL_PREFIX}/share/doc/${SHED_PKG_NAME}-${SHED_PKG_VERSION}

# Configure
./configure --prefix=${SHED_PKG_LOCAL_PREFIX} \
            --docdir=${SHED_PKG_LOCAL_DOCDIR} \
            ${SHED_PKG_LOCAL_STATIC_OPTION} &&

# Build and Install
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1

# Rearrange
if [ -z "${SHED_PKG_LOCAL_OPTIONS[toolchain]}" ]; then
    mkdir -v "${SHED_FAKE_ROOT}/bin" &&
    mv -v "${SHED_FAKE_ROOT}"/usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} "${SHED_FAKE_ROOT}/bin" &&
    mkdir -v "${SHED_FAKE_ROOT}/lib" &&
    mv -v "${SHED_FAKE_ROOT}"/usr/lib/liblzma.so.* "${SHED_FAKE_ROOT}/lib" &&
    ln -svf ../../lib/$(readlink "${SHED_FAKE_ROOT}/usr/lib/liblzma.so") "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_PREFIX}/lib/liblzma.so" || exit 1
fi

# Manage Documentation
if [ -z "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    rm -rf "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_DOCDIR}"
fi
