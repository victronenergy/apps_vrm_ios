source 'https://github.com/CocoaPods/Specs.git'
target "VictronEnergy" do
	pod 'AFNetworking', '~> 2.5'
	pod 'AFNetworkActivityLogger', '~> 2.0.4'
	pod 'SVProgressHUD', '~> 1.1.3'
	pod 'Fabric'
	pod 'Crashlytics'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
        end
    end
end
