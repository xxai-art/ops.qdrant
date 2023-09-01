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

# POST /collections/{collection_name}/points/delete
for await [id] from ITER.bot.clip_same('',{})
  SAME.add id

clip_iter = ->
  iter = ITER.bot.task('cid,rid,iaa,adult',{where:"iaa>25", LIMIT, id:(+process.env.ID) or 0})
  m = new Map
  for await [id,cid,rid,iaa,adult] from iter
    if cid == 1
      if not SAME.has id
        m.set id,[cid,rid,iaa,adult]
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
  li.forEach (i)=>
    {payload} = i
    if 'nsfw' of payload
      payload.sfw = !payload.nsfw
      delete payload.nsfw
    stream.write(i)
    return
  # break

stream.end()
await finished out
process.exit()
