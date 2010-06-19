helpers: require "./helpers"

exports.reporters: require "./reporters"

exports.Suite: class Suite
    constructor: (name) ->
        @name: name or "TestSuite"
        @tests: []

    add: (testCase) ->
        @tests ||= []
        @tests: helpers.append @tests, testCase

exports.Case: class Case
    constructor: (name, testableBlock) ->
        @name: name
        @test: testableBlock

exports.Runner: class Runner
    constructor: (reporter) ->
        @reporter: reporter

    addSuite: (testSuite) ->
        @suites ||= []
        @suites: helpers.append @suites, testSuite

    run: ->
        @reporter.start(this)
        for suite in @suites
            @reporter.startSuite(suite)
            for testCase in suite.tests
                @reporter.startCase(testCase)
                try
                    testCase.test()
                    @reporter.caseSucceed(testCase)
                catch err
                    @reporter.caseFailed(testCase, err)
                finally
                    @reporter.endCase(testCase)
            @reporter.endSuite(suite)

        @reporter.end(this)

exports.suite: new Suite()
exports.test: (caseName, testableBlock)->
    exports.suite.add(new Case(caseName, testableBlock))

helpers.makeGlobal "test", exports.test

