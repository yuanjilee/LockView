
Pod::Spec.new do |s|
  s.name         = "LockView"
  s.version      = "3.0.0"
  s.summary      = "Gesture Lock with Swift"

  s.description  = <<-DESC
                   Gesture Lock with Swift.
                   DESC

  s.homepage     = "https://github.com/yuanjilee/LeeLockView"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = ":type => 'MIT', :file => 'LICENSE'"
  s.author             = { "yuanjilee" => "824528524@qq.com" }
  s.ios.deployment_target = '8.0'

  s.source       = { :git => "https://github.com/yuanjilee/LeeLockView.git", :tag => s.version.to_s }
  s.source_files = 'LockView/Classes/**/*'
  
  s.frameworks = "Foundation", "UIKit"

    s.resource_bundles      = { 'LockView' => [
  'LockView/Assets/**/*.png', 'LockView/Resources/*.lproj'] }

end
