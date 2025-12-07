Pod::Spec.new do |s|
  s.name         = 'AWEFeed'
  s.version      = '1.0.0'
  s.summary      = 'Feed business domain'
  s.homepage     = 'https://example.com'
  s.license      = { :type => 'MIT' }
  s.author       = { 'Demo' => 'demo@example.com' }
  s.source       = { :path => '.' }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.subspec 'ModuleInterface' do |ss|
    ss.source_files = 'ModuleInterface/**/*.{swift}'
  end

  s.subspec 'Service' do |ss|
    ss.source_files = 'Service/**/*.{swift}'
    ss.dependency 'AWEInfra'
    ss.dependency 'AWESearch/ModuleInterface' # 通过接口层使用 Search
  end

  s.subspec 'BizUI' do |ss|
    ss.source_files = 'BizUI/**/*.{swift}'
    ss.resource_bundles = {
      'AWEFeedBizUIResources' => [
        'BizUI/Assets/**/*'
      ]
    }
    ss.dependency 'AWEFeed/Service'
    ss.dependency 'AWELaunchKit'
    ss.dependency 'AWEUIResources'
  end

  s.subspec 'Impl' do |ss|
    ss.source_files = 'Impl/**/*.{swift}'
    ss.dependency 'AWEFeed/ModuleInterface'
    ss.dependency 'AWEFeed/BizUI'
    ss.dependency 'AWELaunchKit'
  end
end
