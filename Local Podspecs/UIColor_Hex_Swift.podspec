Pod::Spec.new do |s|
  s.name         = "UIColor_Hex_Swift"
  s.version      = "3.0.2"
  s.summary      = "Convenience method for creating autoreleased color using RGBA hex string."
  s.homepage     = "https://github.com/yeahdongcn/UIColor-Hex-Swift"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "R0CKSTAR" => "yeahdongcn@gmail.com" }
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => 'https://github.com/yeahdongcn/UIColor-Hex-Swift.git', :tag => "#{s.version}" }
  #s.source_files = 'HEXColor/*.{h,swift}'
  s.frameworks   = ['UIKit']
  s.requires_arc = true

  # 使用Carthage打包Framework
  s.osx.vendored_frameworks = "Carthage/Build/macOS/HEXColor.framework"
  s.tvos.vendored_frameworks = "Carthage/Build/tvOS/HEXColor.framework"
  s.watchos.vendored_frameworks = "Carthage/Build/watchOS/HEXColor.framework"
  s.ios.vendored_frameworks = "Carthage/Build/iOS/HEXColor.framework"
  
  # s.prepare_command = 'carthage build --no-skip-current --platform ios'
  s.prepare_command = <<-CMD
                        mkdir -p Carthage/Build/iOS
                        ln -s "${TMP_PROJECT_DIR}/Carthage/Build/iOS/HEXColor.framework" "Carthage/Build/iOS/HEXColor.framework"
                      CMD
end
