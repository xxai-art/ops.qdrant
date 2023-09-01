#!/usr/bin/env coffee

> @w5/pg/APG > ITER ONE LI0 ONE0
  @w5/qdrant:Q
  msgpackr > PackrStream

{clip} = Q.POST.collections
{points} = clip

LIMIT = 3
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

stream = new PackrStream()

for await m from clip_iter()
  ids = [...m.keys()]
  li = await points {
    ids
    with_payload:true
    with_vector:true
  }
  li.forEach (i)=>
    stream.write(i)
    return
  break

process.exit()
