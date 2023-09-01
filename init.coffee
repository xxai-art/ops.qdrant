#!/usr/bin/env coffee

> @w5/uridir
  @w5/read
  chalk
  @w5/yml > load
  path > join basename
  glob-promise > glob


{blue,yellowBright,redBright} = chalk

ROOT = uridir(import.meta)

URL = process.env.QDRANT_URL+':'+process.env.QDRANT__SERVICE__HTTP_PORT

HEADERS = new Headers()
HEADERS.append("Content-Type", "application/json")
HEADERS.append("api-key", process.env.QDRANT__SERVICE__API_KEY)

init = (db, body_li)=>
  url = URL+"/collections/"+db
  for body,pos in body_li
    console.log blue url
    console.log body
    r = await fetch(
      url
      {
        method: 'PUT'
        headers: HEADERS
        redirect: 'follow'
        body: JSON.stringify body
      }
    )
    {status} = await r.json()
    if status != 'ok'
      console.error redBright status.error
    if pos==0
      url += '/index'
  return

# fetch("http://localhost:3680/collections/test_collection", requestOptions)
#   .then(response => response.text())
#   .then(result => console.log(result))
#   .catch(error => console.log('error', error))

for yml from await glob.glob join ROOT,"db/*.yml"
  db = basename(yml).slice(0,-4)
  console.log yellowBright('→ '+db)
  init db, load(yml)
  # console.log await init(db)
