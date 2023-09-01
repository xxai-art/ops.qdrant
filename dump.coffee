#!/usr/bin/env coffee

iter = ITER.bot.task('cid,rid,iaa,adult',{where:"iaa>25", limit, id:(+process.env.ID) or 0})
