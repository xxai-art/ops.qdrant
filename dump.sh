#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

./dump.coffee

tar cf - ./data | zstd -T0 -19 -o data.zstd

rm -rf ./data
