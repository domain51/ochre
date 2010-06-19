coffee: require "/usr/local/lib/coffee-script/lib/coffee-script"
fs: require "fs"
sys: require "sys"
puts: sys.puts
{spawn, exec}: require "child_process"

option "-c", "--config [FILE]", "configuration file to load"

options: {}

findCoffeeFiles: (dir) ->
    files: fs.readdirSync dir
    file for file in files when file.match(/\.coffee$/)

compileOptions: (source) ->
  o: {source: source}
  o['no_wrap']: options['no-wrap']
  o

sourceFile: (file, opts) ->
    opts.dirs.source + "/" + file

outputFile: (file, opts) ->
    opts.dirs.output + "/" + file.replace(/\.coffee$/, '.js')

compile: (file, opts, callback) ->
    fs.readFile "$opts.dirs.source/$file", (err, code) ->
        if err
            puts "Error! [$err]"
        else
            puts "Compiling " + sourceFile(file, opts) + " to " + outputFile(file, opts)
            code: coffee.compile code.toString()
            fs.writeFile outputFile(file, opts), code
            if callback
                callback()

task "compile", "Compiles all of the CoffeeScript into executable JavaScript", (incoming_options) ->
    src_dir: options.source or "src"
    options.dirs: {
        source: incoming_options.source or "src",
        output: incoming_options.output or "lib",
    }
    files: findCoffeeFiles options.dirs.source
    compile(file, options) for file in files


task "test", "Compile and run all tests", (incoming_options) ->
    invoke "compile", incoming_options
    src_dir: incoming_options.tests or "tests"
    test_options: {
        dirs: {
            source: incoming_options.source or "tests",
            output: incoming_options.output or "tests",
        }
    }
    files: findCoffeeFiles test_options.dirs.source
    execCallback: (error, stdout, stderr) ->
        if stderr.length > 0
            puts stderr
        if stdout.length > 0
            puts stdout
    for file in files
        compile(file, test_options, ->
            test_file: "./$test_options.dirs.output/" + file.replace(/\.coffee/, '.js')
            puts "running " + test_file
            exec "node " + test_file, execCallback
        )

