ochre: require "../src/ochre"

tests: {
    name: "Full test suite for Ochre"
    test_case: require "./test_case"
    test_helpers: require "./test_helpers"
}

if ochre.shouldRun module
    ochre.run(tests)

