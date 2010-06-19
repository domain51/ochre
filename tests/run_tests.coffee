assert: require "assert"
sys: require "sys"
puts: sys.puts

ochre: require "../lib/ochre"

test "hello world example", ->
    assert.ok true

if module == require.main
    puts "Running test suite..."
    reporter = new ochre.reporters.TextReporter()
    runner = new ochre.Runner(reporter)
    runner.addSuite(ochre.suite)
    runner.run()


