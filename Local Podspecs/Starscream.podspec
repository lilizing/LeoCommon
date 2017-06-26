Pod::Spec.new do |s|
  s.name         = "Starscream"
  s.version      = "2.0.4"
  s.summary      = "A conforming WebSocket RFC 6455 client library in Swift for iOS and OSX."
  s.homepage     = "https://github.com/daltoniam/Starscream"
  s.license      = 'Apache License, Version 2.0'
  s.author       = {'Dalton Cherry' => 'http://daltoniam.com', 'Austin Cherry' => 'http://austincherry.me'}
  s.source       = { :git => 'https://github.com/daltoniam/Starscream.git',  :tag => "#{s.version}"}
  s.social_media_url = 'http://twitter.com/daltoniam'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  #s.source_files = 'Source/*.swift'
  s.requires_arc = 'true'

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
