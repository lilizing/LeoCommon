Pod::Spec.new do |s|
  s.name = 'Alamofire'
  s.version = '4.4.0'
  s.license = 'MIT'
  s.summary = 'Elegant HTTP Networking in Swift'
  s.homepage = 'https://github.com/Alamofire/Alamofire'
  s.social_media_url = 'http://twitter.com/AlamofireSF'
  s.authors = { 'Alamofire Software Foundation' => 'info@alamofire.org' }
  s.source = { :git => 'https://github.com/Alamofire/Alamofire.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  # s.source_files = 'Source/*.swift'

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
