require 'rubygems'
require 'bundler'

desc "Build JavaScripts from Ruby"
task :build do
  Bundler.require
  env = Opal::Environment.new
  env.append_path "IGHTMLQuery/Ruby"

  File.open("IGHTMLQuery/JavaScript/html_query.js", "w+") do |out|
    out << env["html_query"].to_s
  end
end

desc "Run tests"
task :test do
  system("xcodebuild -workspace IGHTMLQuery.xcworkspace -scheme IGHTMLQuery -sdk iphonesimulator9.2 test -destination 'platform=iOS Simulator,name=iPhone 6 Plus' | xcpretty -c")
end

task :default => :test
