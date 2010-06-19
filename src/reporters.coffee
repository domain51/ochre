helpers: require "./helpers"
sys: require "sys"
puts: sys.puts

exports.Reporter: class Reporter
    constructor: ->
        @failures: []
        @totals: {
            run: 0,
            pass: 0,
            fail: 0,
        }

    start: (obj) ->
    end: (obj) ->
    startSuite: (suite) ->
    endSuite: (suite) ->
    startCase: (testCase) ->
        ++@totals.run
    endCase: (testCase) ->
    caseSucceed: (testCase) ->
        ++@totals.pass
    caseFailed: (testCase, err) ->
        ++@totals.fail
        @failures: helpers.append @failures or [], err


exports.TextReporter: class BasicTextReporter extends Reporter
    constructor: ->
        super()

    start: (obj) ->
        super()
        puts "Running test suite"

    startSuite: (suite) ->
        super()
        puts "Starting test suite: $suite.name"

    endSuite: (suite) ->
        super()
        puts ""
        if @totals.fail > 0
            puts "Failures:"
            for failure in @failures
                puts failure
                puts ""
        puts "Stats Total/Pass/Fail: $@totals.run/$@totals.pass/$@totals.fail"

    caseSucceed: (testCase) ->
        super(testCase)
        sys.print "."

    caseFailed: (testCase, err) ->
        super(testCase, err)
        sys.print "F"

