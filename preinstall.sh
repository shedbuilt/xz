#!/bin/bash
if [ "$SHED_BUILDMODE" == 'bootstrap' ]; then
    # Remove temporary symlinks created earlier in the bootstrap
    rm -v /usr/lib/liblzma.so.*
fi
