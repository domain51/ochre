# Helper functions that provide some basic behavior

ochre: require "./ochre"

# Extend the `first` Hash with the values of the `second` hash
#
# Does not perform any error checking, so make sure you're handing the correct
# types into this or your may get some unexpected behaviors.
exports.extend: (first, second) ->
    for k, v of second
        first[k]: v

#
# Function for generating a `Suite` out of a provided hash
#
# By default, this does not operate according to the
# [CommonJS](http://wiki.commonjs.org/wiki/Unit_Testing/1.0) `test`
# specification.  Instead of only taking functions that only start with the
# phrase "test", it takes all functions and adds them to the tests.  This
# allows for plain-English (or your preferred language) to be used in
# describing the test case.
#
# You can limit the tests to include only those functions that have a prefix of
# "test" (case-insensitive) at the beginning by including `strictMode: true` in
# the `options` parameter.
#
generateSuite: exports.generateSuite: (hash, options) ->
    options ||= {}
    options.strictMode ||= false
    suite: new ochre.Suite()
    for key, val of hash
        if key == 'name'
            suite.name: val
        else if typeof val == "object"
            suite.add generateSuite val
        else if typeof val == "function"
            if !options.strictMode or key[0..3].toLowerCase() == "test"
                suite.add new ochre.Case(key, val)
    suite

# 
# A simple utility method for answering whether a given module should call
# `run` or not.
#
# The following JavaScript and Python are roughly equivalent in Node.js.
#
# JavaScript:
#   if (module === require.main)
#
# Python:
#   if __name__ == '__main__':
#
# The caveat to this is if the file is run directly via the `coffee` script.
# In that case the `module` that is passed in is not the same as if it were
# being invoked from within Node.js, thus the check of the final characters in
# the `module.id`.
# 
exports.shouldRun: exports.shouldRun: (module) ->
    module == require.main or module.id[-17..module.id.length] == 'lib/coffee-script'

# Simple append functionality
exports.append: (list, value) ->
    newList: list
    newList[list.length]: value
    newList

# Make a function global under the name 
exports.makeGlobal: (name, func) ->
    global[name]: func

