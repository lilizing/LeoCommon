Pod::Spec.new do |s|
  s.name         = "ReactiveCocoa"
  s.version      = "5.0.3"
  s.summary      = "Streams of values over time"
  s.description  = <<-DESC
                   ReactiveCocoa (RAC) is a Cocoa framework built on top of ReactiveSwift. It provides APIs for using ReactiveSwift with Apple's Cocoa frameworks.
                   DESC
  s.homepage     = "https://github.com/ReactiveCocoa/ReactiveCocoa"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author       = "ReactiveCocoa"

  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"

  s.source       = { :git => "https://github.com/ReactiveCocoa/ReactiveCocoa.git", :tag => "#{s.version}" }
  s.source       = { :git => "https://github.com/ReactiveCocoa/ReactiveCocoa.git", :tag => "#{s.version}" }
  #s.source_files = "ReactiveCocoa/*.{swift,h,m}", "ReactiveCocoa/Shared/*.{swift}"
  s.private_header_files = "ReactiveCocoa/ObjCRuntimeAliases.h"
  #s.osx.source_files = "ReactiveCocoa/AppKit/*.{swift}"
  #s.ios.source_files = "ReactiveCocoa/UIKit/*.{swift}", "ReactiveCocoa/UIKit/iOS/*.{swift}"
  #s.tvos.source_files = "ReactiveCocoa/UIKit/*.{swift}"
  s.watchos.exclude_files = "ReactiveCocoa/Shared/*.{swift}"
  s.module_map = "ReactiveCocoa/module.modulemap"

  s.dependency 'ReactiveSwift', '~> 1.1'

  s.pod_target_xcconfig = { "OTHER_SWIFT_FLAGS[config=Release]" => "-suppress-warnings" }

  # 使用Carthage打包Framework
  s.osx.vendored_frameworks = "Carthage/Build/macOS/#{s.name}.framework"
  s.tvos.vendored_frameworks = "Carthage/Build/tvOS/#{s.name}.framework"
  s.watchos.vendored_frameworks = "Carthage/Build/watchOS/#{s.name}.framework"
  s.ios.vendored_frameworks = "Carthage/Build/iOS/#{s.name}.framework"

  # s.prepare_command = 'carthage build --no-skip-current --platform ios'
  s.prepare_command = <<-CMD
                        mkdir -p Carthage/Build/iOS
                        ln -s "${TMP_PROJECT_DIR}/Carthage/Build/iOS/#{s.name}.framework" "Carthage/Build/iOS/#{s.name}.framework"
                      CMD

end
