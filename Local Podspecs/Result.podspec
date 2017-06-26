Pod::Spec.new do |s|
  s.name         = 'Result'
  s.version      = '3.2.3'
  s.summary      = 'Swift type modelling the success/failure of arbitrary operations'

  s.homepage     = 'https://github.com/antitypical/Result'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Rob Rix' => 'rob.rix@github.com' }
  s.source       = { :git => 'https://github.com/antitypical/Result.git', :tag => s.version }
  #s.source_files  = 'Result/*.swift'
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

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
