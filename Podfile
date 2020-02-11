# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'DCP' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for DCP
  pod 'SlideMenuControllerSwift'
  pod 'Material'
  pod 'Localize-Swift'
  pod 'MTBBarcodeScanner'
  pod 'Hippolyte'
  
  pod 'TTGSnackbar'
  pod 'Alamofire'
  pod 'JGProgressHUD'
  pod 'AMPopTip'
  pod 'SwiftyJSON'
  pod  'ImagePicker'
  
  
  use_frameworks!
  
  # Pods for DVS
  
  target 'DCPTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'DCPUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2'
      end
    end
  end
  
end
