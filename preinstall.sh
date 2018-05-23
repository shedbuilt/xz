#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
if [ -n "${SHED_PKG_LOCAL_OPTIONS[bootstrap]}" ]; then
    # Remove temporary symlinks created earlier in the bootstrap
    rm -v /usr/lib/liblzma.so.*
fi
