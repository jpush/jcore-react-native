require 'json'
pjson = JSON.parse(File.read('package.json'))

Pod::Spec.new do |s|

  s.name            = "JCoreRN"
  s.version         = pjson["version"]
  s.homepage        = pjson["homepage"]
  s.summary         = pjson["description"]
  s.license         = pjson["license"]
  s.author          = pjson["author"]
  
  s.ios.deployment_target = '7.0'

  s.source             = { :git => "https://github.com/jpush/jcore-react-native.git", :tag => "#{s.version}" }
  s.source_files       = 'ios/RCTJCoreModule/*.{h,m}'
  s.preserve_paths     = "**/*.js"
  s.vendored_frameworks = "ios/RCTJCoreModule/*.xcframework"
 	s.libraries       = 'z','resolv', 'sqlite3', 'c++.1'
  s.dependency 'React'
end
