
Pod::Spec.new do |s|
  s.name         = "LockView"
  s.version      = "3.1.0"
  s.summary      = "Gesture Lock with Swift"

  s.description  = <<-DESC
                   Gesture Lock with Swift.
                   Support FaceID & TouchID
                   DESC

  s.homepage     = "https://github.com/yuanjilee/LockView"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.#com/screenshots_2.gif"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "yuanjilee" => "824528524@qq.com" }
  s.ios.deployment_target = '8.0'

  s.source       = { :git => "https://github.com/yuanjilee/LockView.git", :tag => s.version.to_s }

  s.frameworks = "Foundation", "UIKit"

  s.source_files = 'LockView/Classes/**/*'
  s.resource_bundles      = { 'LockView' => [
  'LockView/Assets/**/*.png', 'LockView/Resources/*.lproj'] }

end
