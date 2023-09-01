#!/usr/bin/env coffee

> fs > createReadStream
  path > join
  ./conf > DATA
  msgpackr > UnpackrStream
  stream-to-it > source

clip = createReadStream join DATA,'clip.msgpack'
unpack = new UnpackrStream
clip.pipe unpack

for await i from source unpack
  console.log i

process.exit()
