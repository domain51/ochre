assert: require "assert"
sys: require "sys"
puts: sys.puts

ochre: require "../src/ochre"
test: ochre.test

tests: {
    name: "Full test suite for Ochre"
    test_case: require "./test_case"
    test_helpers: require "./test_helpers"
}


if ochre.shouldRun module
    ochre.run(tests)

