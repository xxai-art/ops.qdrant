#!/usr/bin/env coffee

> @w5/pg/APG > ITER ONE LI0 ONE0
  @w5/qdrant:Q
  msgpackr > PackrStream
  fs/promises > mkdir
  fs > createWriteStream
  stream > finished:_finished
  util > promisify
  path > join
  ./conf > DATA

finished = promisify _finished

await mkdir(DATA, { recursive: true })

{clip} = Q.POST.collections
{points} = clip

LIMIT = 999
SAME = new Set()
ID_STAR= new Map

for await [id,star] from ITER.bot.civitai_img('star',{})
  ID_STAR.set id, star
# POST /collections/{collection_name}/points/delete
for await [id] from ITER.bot.clip_same('',{})
  SAME.add id

clip_iter = ->
  iter = ITER.bot.task('cid',{where:"iaa>25", id:(+process.env.ID) or 0})
  m = new Map
  for await [id,cid] from iter
    # if cid == 1
    if not SAME.has id
      m.set id,[]
      if m.size >= LIMIT
        yield m
        m = new Map
  if m.size
    yield m

  return

out = createWriteStream(join DATA,'clip.msgpack')

stream = new PackrStream()
stream.pipe(out)

runed = 0
for await m from clip_iter()
  ids = [...m.keys()]
  li = await points {
    ids
    with_payload:true
    with_vector:true
  }
  runed += li.length
  console.log runed
  for i from li
    {payload, id} = i
    delete payload.w
    delete payload.h
    delete payload.r
    if 's' of payload
      payload.q = payload.s
      delete payload.s
    if payload.sfw != false
      delete payload.sfw
    if runed % 100 == 0
      console.log id, payload
    stream.write(i)


stream.end()
await finished out
process.exit()
