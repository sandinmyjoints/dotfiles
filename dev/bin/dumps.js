#!/usr/bin/env coffee

RE_INDENTATION = /\n[ ]+/g
# Mimic Python's json.dumps. See:
# https://docs.python.org/2/library/json.html#json.dumps
dumps = (obj) ->
  JSON.stringify(obj, null, ' ')
    .replace(RE_INDENTATION, '')
    .replace(/\\"/g, '"')
    .replace(/^"/, '')
    .replace(/"$/, '')
