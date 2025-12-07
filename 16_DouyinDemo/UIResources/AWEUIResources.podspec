Pod::Spec.new do |s|
  s.name         = 'AWEUIResources'
  s.version      = '1.0.0'
  s.summary      = 'Shared UI assets (icons, colors, etc.)'
  s.homepage     = 'https://example.com'
  s.license      = { :type => 'MIT' }
  s.author       = { 'Demo' => 'demo@example.com' }
  s.source       = { :path => '.' }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.resource_bundles = {
    'AWEUIResources' => [
      'Assets/**/*'
    ]
  }

  s.source_files = 'Sources/**/*.{swift}'
end
