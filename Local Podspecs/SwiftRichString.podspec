Pod::Spec.new do |s|
  s.name = 'SwiftRichString'
  s.version = '0.9.8'
  s.summary = 'Elegant and painless Attributed String (NSAttributedString) in Swift'
  s.homepage = 'https://github.com/malcommac/SwiftRichString'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Daniele Margutti' => 'me@danielemargutti.com' }
  s.social_media_url = 'http://twitter.com/danielemargutti'
  s.source = { :git => 'https://github.com/malcommac/SwiftRichString.git', :tag => "#{s.version}" }
  #s.source_files = 'Sources/**/*.swift'
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true
  s.module_name = 'SwiftRichString'

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
