glob = require 'glob'
fs = require 'fs'
path = require 'path'
_ = require 'lodash'
mkdirp = require 'mkdirp'

argv = require('optimist')
  .default('test', 'test')
  .default('src', 'src')
  .default('ext', '.coffee')
  .argv

{src, test, ext} = argv

defaults =
  ".coffee": (input, dest,  depth) ->
    depthText = path.join (_.times depth, (n) -> '..')...
    inputExtless = input.replace ".coffee", ''
    """
    # require '#{depthText}/#{inputExtless}'
    describe \"#{inputExtless}\", ->
      it "should be written"
    """

  ".js": (input, dest,  depth) ->
    depthText = path.join (_.times depth, (n) -> '..')...
    inputExtless = input.replace ".coffee", ''
    """
    // require('#{depthText}/#{inputExtless}')
    describe(\"#{inputExtless}\", function(){
      it("should be written")
    });
    """

ensureTestDir = ->
  unless fs.existsSync test
    mkdirp.sync test

generate = ->
  glob "#{src}/**/*#{ext}", (err, files) ->
    files.map (f) ->
      input = f
      output = f.replace src, test

      depth = f.match(/\//g).length
      if fs.existsSync output
        console.log "skip", output
      else
        unless fs.existsSync path.dirname(output)
          mkdirp.sync path.dirname(output)
        console.log "create", output
        result = defaults[ext](input, output, depth)
        fs.writeFileSync output, result

module.exports = ->
  ensureTestDir()
  generate()
