
Pod::Spec.new do |s|
  s.name             = 'YCAssistivePlugin'
  s.version          = '0.1.0'
  s.summary          = 'A short description of YCAssistivePlugin.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/shenweihang/YCAssistivePlugin'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'shenweihang' => 'shenweihang_2019@163.com' }
  s.source           = { :git => 'https://github.com/shenweihang/YCAssistivePlugin.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'YCAssistivePlugin/Classes/**/*'
  
  s.resource_bundles = {
    'YCAssistivePlugin' => ['YCAssistivePlugin/Assets/Resource.xcassets']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'YYModel'
end
