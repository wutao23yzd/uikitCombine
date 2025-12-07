Pod::Spec.new do |s|
  s.name         = 'AWEUITheme'
  s.version      = '1.0.0'
  s.summary      = 'Global UI theme: colors, fonts, base nav & base view controller'
  s.homepage     = 'https://example.com'
  s.license      = { :type => 'MIT' }
  s.author       = { 'Demo' => 'demo@example.com' }
  s.source       = { :path => '.' }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/**/*.{swift}'

  s.dependency 'AWEUIResources'
  s.dependency 'AWELaunchKit'
end
