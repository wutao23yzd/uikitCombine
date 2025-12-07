Pod::Spec.new do |s|
  s.name         = 'AWESearch'
  s.version      = '1.0.0'
  s.summary      = 'Search business domain'
  s.homepage     = 'https://example.com'
  s.license      = { :type => 'MIT' }
  s.author       = { 'Demo' => 'demo@example.com' }
  s.source       = { :path => '.' }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.subspec 'ModuleInterface' do |ss|
    ss.source_files = 'ModuleInterface/**/*.{swift}'
  end

  s.subspec 'Basic' do |ss|
    ss.source_files = 'Basic/**/*.{swift}'
    ss.dependency 'AWESearch/ModuleInterface'
  end

  s.subspec 'Model' do |ss|
    ss.source_files = 'Model/**/*.{swift}'
    ss.dependency 'AWESearch/ModuleInterface'
  end

  s.subspec 'Service' do |ss|
    ss.source_files = 'Service/**/*.{swift}'
    ss.dependency 'AWESearch/Model'
    ss.dependency 'AWESearch/Basic'
    ss.dependency 'AWEInfra'
  end

  s.subspec 'BizUI' do |ss|
    ss.source_files = 'BizUI/**/*.{swift}'
    ss.resource_bundles = {
      'AWESearchBizUIResources' => [
        'BizUI/Assets/**/*'
      ]
    }
    ss.dependency 'AWESearch/Service'
    ss.dependency 'AWEUIResources'
    ss.dependency 'AWEUITheme'
  end

  s.subspec 'Impl' do |ss|
    ss.source_files = 'Impl/**/*.{swift}'
    ss.dependency 'AWESearch/ModuleInterface'
    ss.dependency 'AWESearch/BizUI'
    ss.dependency 'AWELaunchKit'
    ss.dependency 'AWEInfra'
  end
end
