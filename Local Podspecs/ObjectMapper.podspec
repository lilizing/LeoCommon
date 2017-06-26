Pod::Spec.new do |s|
  s.name = 'ObjectMapper'
  s.version = '2.2.7'
  s.license = 'MIT'
  s.summary = 'JSON Object mapping written in Swift'
  s.homepage = 'https://github.com/Hearst-DD/ObjectMapper'
  s.authors = { 'Tristan Himmelman' => 'tristanhimmelman@gmail.com' }
  s.source = { :git => 'https://github.com/Hearst-DD/ObjectMapper.git', :tag => s.version.to_s }

  s.watchos.deployment_target = '2.0'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'


  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '3.1',
  }

  s.requires_arc = true
  #s.source_files = 'Sources/**/*.swift'

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
