#!/usr/bin/env coffee

> @w5/qdrant:Q


{scroll, payload:update, delete: del} = Q.POST.collections.clip.points
# sfw = 'sfw'
# nsfw = 'n'+sfw
ing = []
loop
  { points } = await scroll {
    limit: 1024
    with_payload: true
    filter: must_not: [
      is_empty:
        key: 'w'
    ]
  }
  console.log points
  if not points.length
    break
#
#   for i from points
#     {payload,id} = i
#     console.log id, payload
#     payload.sfw = !payload.nsfw
#     delete payload.nsfw
#     ing.push update {
#       points: [id]
#       payload
#     }
#     ing.push del {
#       points: [id]
#       keys: [nsfw]
#     }
#     if ing.length > 256
#       await Promise.all ing
#       ing = []
#
# await Promise.all ing

process.exit()
