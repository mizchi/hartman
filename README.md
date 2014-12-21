# Hartman

Automatic mocha style unit test generator by dirs for common.js envinroment(node.js browserify).

Good for you.

```
npm install -g hartman
```

## How to use

```
$ hartman --src src --test test --input js --ouput coffee --suffix spec
```

```
app/
	foo.js
	bar.js
spec/
	foo-spec.coffee
	bar-spec.coffee
```

Generated file

```coffee
# require '../src/foo'
describe "src/foo", ->
  it "should be written"
```

## Option files

hartman.json
```
{
  "srcDir": "src",
  "testDir": "spec",
  "inputType": "coffee",
  "outputType": "ts",
  "suffix": "spec",
  "excludes": ['src/ex.coffee']
}
```

and run `hartman`

## LICENSE

MIT
