require 'cocoapods-catalyst-support'

# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ToDoToday' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ToDoToday

	pod 'Firebase/Analytics'
	pod 'Google-Mobile-Ads-SDK'



end

# Configure your macCatalyst dependencies
catalyst_configuration do
	# Uncomment the next line for a verbose output
	# verbose!

	 ios 'Firebase/Analytics'
	 ios 'Google-Mobile-Ads-SDK' # This dependency will only be available for iOS
	# macos '<pod_name>' # This dependency will only be available for macOS
end

# Configure your macCatalyst App
post_install do |installer|
	installer.configure_catalyst
end
