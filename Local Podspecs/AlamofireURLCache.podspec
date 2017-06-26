Pod::Spec.new do |s|
  s.name = 'AlamofireURLCache'
  s.version = '0.1'
  s.license = 'MIT'
  s.summary = 'Alamofire URL Cache Extension'
  s.authors = { 'AlamofireURLCache' => 'lilizing@qq.com' }
  s.homepage = 'https://github.com/kenshincui/AlamofireURLCache'
  s.source = { :git => 'https://github.com/kenshincui/AlamofireURLCache.git', :branch => "master" }

  s.platform = :ios, "8.0"

  s.source_files = 'AlamofireURLCache/*.swift'

  s.dependency 'Alamofire', '~> 4.4'

  # 使用Carthage打包Framework
  # s.osx.vendored_frameworks = "Carthage/Build/macOS/#{s.name}.framework"
  # s.tvos.vendored_frameworks = "Carthage/Build/tvOS/#{s.name}.framework"
  # s.watchos.vendored_frameworks = "Carthage/Build/watchOS/#{s.name}.framework"
  # s.ios.vendored_frameworks = "Carthage/Build/iOS/#{s.name}.framework"

  # s.prepare_command = 'carthage build --no-skip-current --platform ios'
  # s.prepare_command = <<-CMD
  #                       mkdir -p Carthage/Build/iOS
  #                       ln -s "${TMP_PROJECT_DIR}/Carthage/Build/iOS/#{s.name}.framework" "Carthage/Build/iOS/#{s.name}.framework"
  #                     CMD
end
