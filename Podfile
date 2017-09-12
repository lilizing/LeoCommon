# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

inhibit_all_warnings!

source 'https://github.com/lilizing/PrivatePods.git'
source 'https://github.com/CocoaPods/Specs.git'

abstract_target 'Leo' do
  # Uncomment this line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!
  
  #  pod 'ReactiveCocoa', '~> 5.0.0'
  pod 'UIColor_Hex_Swift', '~> 3.0.2'
  pod 'SwiftRichString'
  pod 'SnapKit', '~> 3.2.0'
  pod 'Alamofire', '~> 4.5'
  pod 'ObjectMapper', '~> 2.2'
  pod 'Presentr'
  pod 'Result', '~> 3.0.0'
  
  pod 'RxSwift',    '~> 3.0'
  pod 'RxCocoa',    '~> 3.0'
  
  pod 'RxGesture', :git=>'https://github.com/RxSwiftCommunity/RxGesture.git'

  target 'LeoCommon'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            #            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            config.build_settings['SWIFT_VERSION'] = '3.2'
            config.build_settings['SDKROOT'] = 'iphoneos'
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
