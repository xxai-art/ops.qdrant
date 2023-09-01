#!/usr/bin/env coffee

> @w5/uridir
  path > join

export ROOT = uridir import.meta
export DATA = join(ROOT, 'data')
