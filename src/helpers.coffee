# Helper functions that provide some basic behavior

# Extend the `first` Hash with the values of the `second` hash
#
# Does not perform any error checking, so make sure you're handing the correct
# types into this or your may get some unexpected behaviors.
exports.extend: (first, second) ->
    for k, v of second
        first[k]: v


# Simple append functionality
exports.append: (list, value) ->
    newList: list
    newList[list.length]: value
    newList

# Make a function global under the name 
exports.makeGlobal: (name, func) ->
    global[name]: func

