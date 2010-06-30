#
# Ochre testing suite Java/CoffeeScript
#
# This provides a simple mechanism for grouping together test Cases into Suites
# to be run together.  This file provides the basic entry-point into Ochre.
#


# Load other modules
helpers: require "./helpers"
reporters: require "./reporters"

# 
# ## Suite & Case
#

#
# The `Suite` provides a mechanism for group a series of `Case` classes
# together.
Suite: exports.Suite: class Suite
    # It requires a optional `name`, all other values are set from outside the
    # class by its clients.
    constructor: (name) ->
        @name: name or "TestSuite"
        @tests: []
        @reporter: false
        @insideSuite: false


    # Add a new `runnable` to this suite
    #
    # Runnables are anything that has a `run` method on it.  This can be
    # another `Suite` or an individual `Case`.
    add: (runnable) ->
        @tests ||= []
        @tests: helpers.append @tests, runnable

    # Recursively run through all of the registered values in `@tests` and call
    # `run` on them, stopping to call `Reporter.starteSuite` and
    # `Reporter.endSuite` before and after the test is run.
    #
    # Each runnable that's stored inside `@test` is passed a copy of this instance's
    # `@reporter` and has its `insideSuite` set to true.
    #
    # `insideSuite` is useful in the context of reporting which can silently
    # ignore `startSuite` and `endSuite` calls on the nested suites if it
    # chooses to.
    run: ->
        @reporter.startSuite this
        for runnable in @tests
            runnable.reporter: @reporter
            runnable.insideSuite: true
            runnable.run()

        @reporter.endSuite this


#
# A Case represents an individual test case, generally referred to as a [Test
# Method](http://xunitpatterns.com/Test%20Method.html).
#
Case: exports.Case: class Case
    # It requires both a `name` as a string and a `testableBlock` which is
    # should be a callable function.
    constructor: (name, testableBlock) ->
        @name: name
        @test: testableBlock
        @reporter: false

    # Run the test that this represents via its `@test` property.
    #
    # The `run` method is also responsible for providing its `@reporter` with
    # updates as to the state of this case.
    run: ->
        @reporter.startCase this
        try
            @test()
            @reporter.caseSucceeded this
        catch err
            @reporter.caseFailed this, err
        finally
            @reporter.endCase this

#
# The main runner of Ochre.  It's responsible for running all of the various
# test cases for the modules that were passed in.
#
run: (module) ->
    reporter = new reporters.TextReporter()
    reporter.start
    suite: helpers.generateSuite module
    suite.reporter: reporter
    suite.run()
    reporter.end
#
# Export all of the various methods that this exposes
#
helpers.extend exports, {
    run: run
    reporters: reporters
    shouldRun: helpers.shouldRun
    Case: Case
    Suite: Suite
}


