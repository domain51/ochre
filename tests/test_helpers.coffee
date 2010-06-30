assert: require "assert"
ochre: require "../lib/ochre"

helpers: require "../lib/helpers"

exports.name: "Test Suite for various helper functions"
exports.tests: {
    "extend adds values of the second hash to the first": ->
        first: {foo: "bar", bar: "foo"}
        second: {foobar: "barfoo", barfoo: "foobar"}

        assert.ok typeof first.foobar == "undefined"
        helpers.extend first, second
        assert.equal first.foobar, "barfoo"
}

