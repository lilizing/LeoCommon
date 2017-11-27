# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

inhibit_all_warnings!

source 'https://github.com/lilizing/PrivatePods.git'
source 'https://github.com/CocoaPods/Specs.git'

abstract_target 'Leo' do
  # Uncomment this line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!
  
  #  pod 'ReactiveCocoa', '~> 5.0.0'
  pod 'ObjectMapper', '3.1.0'
  
  pod 'SwiftRichString', '1.0.1'
  pod 'SnapKit', '4.0.0'
  
  pod 'Alamofire', '4.5.1'
  
  pod 'RxSwift',    '4.0.0'
  pod 'RxCocoa',    '4.0.0'
  
  #源码方式（因为Target和工程名称不一致，所以只能采用源码方式引入）
  pod 'UIColor_Hex_Swift', :git => 'https://github.com/yeahdongcn/UIColor-Hex-Swift.git'
  
  #以下库正在源码研究中，所以暂且以源码方式引入
  pod 'RxKeyboard', '0.7.1'
  
  #    pod 'SVProgressHUD', :git => 'https://github.com/lilizing/SVProgressHUD.git' #修改了文本边距值
  
  #最低支持修改为8.0
  pod 'RxGesture', '~> 1.2'
  pod 'Reusable', '~> 4.0'
  
  target 'LeoCommon'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            #            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            config.build_settings['SWIFT_VERSION'] = '4.0'
            config.build_settings['SDKROOT'] = 'iphoneos'
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
