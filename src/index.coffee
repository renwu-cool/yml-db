import fs from 'fs-extra'
import yaml from 'js-yaml'
import isEqual from 'lodash/isEqual'

class YamlDb
  constructor:(@file)->
    @dict = yaml.load(@yml()) or {}

  get:(key)->
    @dict[key]

  yml:->
    {file} = @
    if fs.existsSync file
      return fs.readFileSync file
    ""

  set:(key, val)->
    _set = (k,v)=>
      exist = k of @dict
      if exist
        old = @dict[k]
        w = isEqual old,v
      else
        w = true
      if w
        @dict[k] = v
      return (w or false)

    if key.constructor == Object
      write = false
      for i, val of key
        write |= _set(i,val)
    else
      write = _set key,val
    if write
      fs.outputFileSync @file, yaml.dump(@dict)
    return write

export default (file)->
  new YamlDb(file+".yml")

# not module.parent and do =>
#   test = module.exports("/tmp/test")
#   test.set {
#     a:1
#     b:2
#   }
