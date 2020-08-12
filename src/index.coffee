fs = require 'fs-extra'
yaml = require 'js-yaml'

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
        if old != v
          w = true
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

module.exports = (file)->
  new YamlDb(file+".yml")

# not module.parent and do =>
#   test = module.exports("/tmp/test")
#   test.set {
#     a:1
#     b:2
#   }
