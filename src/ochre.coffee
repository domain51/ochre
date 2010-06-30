helpers: require "./helpers"

reporters: exports.reporters: require "./reporters"

Suite: exports.Suite: class Suite
    constructor: (name) ->
        @name: name or "TestSuite"
        @tests: []

    add: (testCase) ->
        @tests ||= []
        @tests: helpers.append @tests, testCase

Case: exports.Case: class Case
    constructor: (name, testableBlock) ->
        @name: name
        @test: testableBlock

Runner: exports.Runner: class Runner
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


knownSuites: {}
test: exports.test: (caseName, testableBlock)->
    baseName: (f) ->
        a: f.split '/'
        a[a.length-1]

    suiteName: module.parent.exports.name || baseName module.parent.filename
    suite: knownSuites[suiteName] ||= new Suite(suiteName)
    suite.add(new Case(caseName, testableBlock))

main: exports.main: ->
    reporter = new reporters.TextReporter()
    runner = new Runner(reporter)
    runner.addSuite(suite) for suiteName, suite of knownSuites
    runner.run()


