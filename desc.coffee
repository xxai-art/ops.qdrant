#!/usr/bin/env coffee

> ./conf > ROOT
  path > join extname
  fs/promises > readdir
  @w5/qdrant:Q

DB = join ROOT,'db'

{collections} = Q.GET

ext = '.yml'
for i from (await readdir(DB)).filter( (file) => extname(file) == ext)
  name = i.slice(0,4)
  console.log name
  console.log await collections[name]()

