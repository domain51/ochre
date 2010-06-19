
# Simple append functionality
exports.append: (list, value) ->
    newList: list
    newList[list.length]: value
    newList

# Make a function global under the name 
exports.makeGlobal: (name, func) ->
    global[name]: func

