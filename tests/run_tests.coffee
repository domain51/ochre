assert: require "assert"
sys: require "sys"
puts: sys.puts

ochre: require "../lib/ochre"
test: ochre.test

exports.name = "Full test suite for Ochre"

test "hello world example", ->
    assert.ok true

if module == require.main
    ochre.main()

