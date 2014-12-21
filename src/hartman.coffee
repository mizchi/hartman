glob = require 'glob'
fs = require 'fs'
path = require 'path'
_ = require 'lodash'
mkdirp = require 'mkdirp'

argv = require('optimist')
  .default('test', 'test')
  .default('src', 'src')
  .default('input', 'coffee')
  .default('output', 'coffee')
  .default('suffix', 'test')
  .argv

Exts =
  coffee: '.coffee'
  ts: '.ts'
  js: '.js'

srcDir = argv.src
testDir = argv.test
inputType = argv.input
outputType = argv.output
suffix = '-'+argv.suffix

# Override by setting file
cwd = process.cwd()
optPath = path.join(cwd, 'hartman.json')
if fs.existsSync optPath
  opt = require(optPath)
  srcDir = opt.srcDir if opt.srcDir
  testDir = opt.testDir if opt.testDir
  inputType = opt.inputType if opt.inputType
  outputType = opt.outputType if opt.outputType
  suffix = '-'+opt.suffix if opt.suffix

defaultHandlerByType =
  coffee: (inputType, inputPath, dest,  depth) ->
    depthText = path.join (_.times depth, (n) -> '..')...
    inputExtless = inputPath.replace Exts[inputType], ''
    """
    # require '#{depthText}/#{inputExtless}'
    describe \"#{inputExtless}\", ->
      it "should be written"
    """

  js: (inputType, inputPath, dest,  depth) ->
    depthText = path.join (_.times depth, (n) -> '..')...
    inputExtless = inputPath.replace Exts[inputType], ''
    """
    // require('#{depthText}/#{inputExtless}')
    describe(\"#{inputExtless}\", function(){
      it("should be written")
    });
    """

  ts: (inputType, inputPath, dest,  depth) ->
    depthText = path.join (_.times depth, (n) -> '..')...
    inputExtless = inputPath.replace Exts[inputType], ''
    """
    // require('#{depthText}/#{inputExtless}')
    describe(\"#{inputExtless}\", function(){
      it("should be written")
    });
    """

ensureTestDir = ->
  unless fs.existsSync testDir
    mkdirp.sync testDir

generate = ->
  ext = Exts[inputType]
  glob "#{srcDir}/**/*#{ext}", (err, files) ->
    files.map (fpath) ->
      inputPath = fpath
      outputPath = fpath
        .replace(srcDir, testDir) # rootdir
        .replace(Exts[inputType], suffix+Exts[outputType]) # suffix with ext

      depth = fpath.match(/\//g).length
      if fs.existsSync outputPath
        console.log "skip", outputPath
      else
        unless fs.existsSync path.dirname(outputPath)
          mkdirp.sync path.dirname(outputPath)
        console.log "create", outputPath
        result = defaultHandlerByType[outputType](inputType, inputPath, outputPath, depth)
        fs.writeFileSync outputPath, result

module.exports = ->
  ensureTestDir()
  generate()
