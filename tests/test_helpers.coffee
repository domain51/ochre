assert: require "assert"
ochre: require "../src/ochre"
helpers: require "../src/helpers"

exports.name: "Test Suite for various helper functions"
exports.tests: {
    "extend adds values of the second hash to the first": ->
        first: {foo: "bar", bar: "foo"}
        second: {foobar: "barfoo", barfoo: "foobar"}

        assert.ok typeof first.foobar == "undefined"
        helpers.extend first, second
        assert.equal first.foobar, "barfoo"

    "generateSuite adds all of the functions in a hash to a suite and returns it": ->
        emptyFunc: ->
        someHash: {
            "some random test": emptyFunc
        }

        suite: helpers.generateSuite someHash
        assert.equal 1, suite.tests.length
        assert.equal "some random test", suite.tests[0].name
        assert.equal emptyFunc, suite.tests[0].test

    "generateSuite uses the name value of the property provided to it if available": ->
        someHash: {
            name: "foobar"
        }
        suite: helpers.generateSuite someHash
        assert.equal suite.name, someHash.name

    "generateSuite can recursively create additional suites": ->
        emptyFunc: ->
        someHash: {
            someOtherHash: {
                name: "foobar"
                "some random test": emptyFunc
            }
        }

        suite: helpers.generateSuite someHash
        assert.equal 1, suite.tests.length
        assert.equal 1, suite.tests[0].tests.length
        assert.equal emptyFunc suite.tests[0].tests[0]

    "generateSuite looks for a test prefix if in strict mode": ->
        one: -> "one"
        two: -> "two"

        someHash: {
            "should not be in the tests": one
            "test should be picked up": two
        }

        suite: helpers.generateSuite someHash, {strictMode: true}
        assert.equal 1, suite.tests.length

    "in strict mode, generateSuite doesn't pay attention to case to determine tests": ->
        emptyFunc: ->
        someHash: {
            "TEST should be picked up": emptyFunc
            "Test should be picked up": emptyFunc
            "TeSt should be picked up": emptyFunc
            "test should be picked up": emptyFunc
        }

        suite: helpers.generateSuite someHash, {strictMode: true}
        assert.equal 4, suite.tests.length


}

