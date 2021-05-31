#!/bin/bash

# opus repo v1.3.1 from xiph
git clone https://gitlab.xiph.org/xiph/opus
cd opus && git checkout v1.3.1

# build lib
./autogen.sh
emconfigure ./configure --disable-rtcd --disable-intrinsics --disable-shared \
  --enable-static  --disable-stack-protector --disable-hardening
emmake make -j$(nproc)

# should ouput libopus.a in .libs/ that is linkable with emcc
