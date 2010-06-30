assert: require "assert"
ochre: require "../lib/ochre"
test: ochre.test

exports.name: "Unit tests for ochre.Case"
exports.tests: {
    "case has name property equal to what it is instantiated with": ->
        testCase: ochre.Case("Some test", ->)
        assert.equal "Some test", testCase.name

    "case has a test property equal to the callback passed in": ->
        foobar: ->
        testCase: ochre.Case("foobar", foobar)
        assert.equal foobar, testCase.test
}

