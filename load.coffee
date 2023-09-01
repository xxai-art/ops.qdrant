#!/usr/bin/env coffee

> fs > createReadStream
  path > join
  ./conf > DATA
  @w5/qdrant:Q
  msgpackr > UnpackrStream
  stream-to-it > source

{clip} = Q.PUT.collections
{points} = clip

clip = createReadStream join DATA,'clip.msgpack'
unpack = new UnpackrStream
clip.pipe unpack

t = []
for await i from source unpack
  t.push i
  if t.length > 99
    await points points:t
    t = []
    console.log i.id

if t.length
  await points points:t

process.exit()
