require 'rubygems'
require 'bundler'
Bundler.require

desc "Build JavaScripts from Ruby"
task :build do  
  env = Opal::Environment.new
  env.append_path "IGHTMLQuery/Ruby"

  File.open("IGHTMLQuery/JavaScript/html_query.js", "w+") do |out|
    out << env["html_query"].to_s
  end
end

desc "Run tests"
task :test do
  exec('xctool GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES clean test')
end

task :default => :build