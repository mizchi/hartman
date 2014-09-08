# Hartman

Automatic mocha style unit test generator by dirs for common.js envinroment(node.js browserify).

Good for you.


```
npm install -g hartman
```

## How to use

```
$ hartman --src app --test test --ext ".coffee"
```

```
app/
	foo.coffee
	bar.coffee
test/
	foo.coffee
	bar.coffee
```

Generate file

```coffee
# require '../src/foo'
describe "src/foo", ->
  it "should be written"
```

## LICENSE

MIT
