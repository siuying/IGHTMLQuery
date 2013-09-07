namespace :test do
  desc "Run the IGHTMLQuery Tests for iOS"
  task :ios do
    $ios_success = system("xctool -workspace IGHTMLQuery.xcworkspace -scheme IGHTMLQuery -sdk iphonesimulator -configuration Release test")
  end
end

task :default => 'test:ios'