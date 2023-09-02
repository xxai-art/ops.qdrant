#!/usr/bin/env coffee

> @w5/qdrant:Q


{scroll, payload:update} = Q.POST.collections.clip.points
sfw = 'sfw'
ing = []
loop
  { points } = await scroll {
    limit: 1024
    with_payload: true
    filter: must: [
      is_empty:
        key: sfw
    ]
  }
  if not points.length
    break

  for i from points
    {payload,id} = i
    payload.sfw = !payload.nsfw
    delete payload.nsfw
    console.log id
    ing.push update {
      points: [id]
      payload
    }
    if ing.length > 1024
      await Promise.all ing
      ing = []

await Promise.all ing

process.exit()
