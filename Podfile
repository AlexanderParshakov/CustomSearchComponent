platform :ios, '11.0'

target 'SearchComponent' do
    use_frameworks!
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'lottie-ios'
    pod 'ANZBreadcrumbsNavigationController'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['LD_NO_PIE'] = 'NO'
        end
    end
end
