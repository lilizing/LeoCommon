Pod::Spec.new do |s|
  s.name         = "Presentr"
  s.version      = "1.2.3"
  s.summary      = "A simple Swift wrapper for custom view controller presentations."
  s.description  = <<-DESC
                    Simplifies creating custom view controller presentations. Specially the typical ones we use which are a popup, an alert, or a any non-full-screen modal. Abstracts having to deal with custom presentation controllers and transitioning delegates
                   DESC
  s.homepage     = "http://github.com/icalialabs/Presentr"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Daniel Lozano" => "dan@danielozano.com" }
  s.social_media_url   = "http://twitter.com/danlozanov"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/icalialabs/Presentr.git", :tag => "1.2.3" }
  #s.source_files = "Presentr/**/*.{swift}"
  s.resources    = "Presentr/**/*.{xib,ttf}"

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
