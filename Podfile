platform :ios, '14.0'

target 'ThreeOneOSFive' do
  # No dependencies - pure Swift + UIKit
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      flutter_additional_ios_build_settings(target)
      target.build_configurations.each do |config|
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
          '$(inherited)',
          'COCOAPODS=1',
        ]
      end
    end
  end
end
