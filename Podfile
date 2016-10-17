# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target ‘Efl' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Efl
  pod 'Alamofire', '~> 3.1.2'
  pod 'AlamofireImage', '~> 2.0'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
  pod 'FBSDKMessengerShareKit'
#pod 'PMKVObserver'

  target ‘EflTests' do

      #inherit! :search_paths
    # Pods for testing
  end

  target ‘EflUITests' do
      #inherit! :search_paths
    # Pods for testing
  end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
end
