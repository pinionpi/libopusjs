#!/bin/bash

# opus repo v1.3.1 from xiph
git clone https://gitlab.xiph.org/xiph/opus
cd opus && git checkout v1.3.1

# build lib
./autogen.sh
emconfigure ./configure --disable-rtcd --disable-intrinsics --disable-shared \
  --enable-static  --disable-stack-protector --disable-hardening
emmake make -j$(nproc)

# should output libopus.a in .libs/ that is linkable with emcc
cd ..

## build wasm
# usage: ./build.sh [flags]
# asm.js release flags: -O2 --memory-init-file 0
# wasm release flags: -O2 -s WASM=1 -s ALLOW_MEMORY_GROWTH=1
em++ api.cpp -Iopus/include -Lopus/.libs -lopus --pre-js preapi.js \
  --post-js api.js -s EXPORTED_FUNCTIONS='["_free"]' $@ -o libopus.js
