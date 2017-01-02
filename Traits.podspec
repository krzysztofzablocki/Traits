#
# Be sure to run `pod lib lint Traits.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Traits'
  s.version          = '0.1.0'
  s.summary          = 'Traits is a library that allows you to change traits of native iOS elements e.g. UIKit views.'

  s.description      = <<-DESC
Traits is a library that allows you to change traits of native iOS elements e.g. UIKit views.
It requires almost no changes in your code, and supports live design changes on running iOS applications.
                       DESC

  s.homepage         = 'https://github.com/krzysztofzablocki/Traits'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Krzysztof Zabłocki' => 'krzysztof.zablocki@pixle.pl' }
  s.source           = { :git => 'https://github.com/krzysztofzablocki/Traits.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/merowing_'
  s.preserve_paths = "Pod/Assets/*.{sh,swift}"

  s.ios.deployment_target = '8.0'
  s.source_files = 'Traits/Classes/**/*'
  s.dependency 'ObjectMapper'
  s.dependency 'KZFileWatchers'
end
