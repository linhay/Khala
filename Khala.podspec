Pod::Spec.new do |s|
  s.name    = 'Khala'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'For we are bound by the Khala.(神圣的卡拉连接着我们.)'
  
  s.homepage  = 'https://github.com/linhay/Khala'
  s.author    = { 'linhey' => 'is.linhay@outlook.com' }
  s.source    = { :git => 'https://github.com/linhay/Khala.git', :tag => s.version.to_s }
  
  s.swift_version = '4.2'

  s.ios.deployment_target = '8.0'
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'
  
  s.source_files = ['Sources/*.{swift,h}']
  s.public_header_files = ['Sources/Khala.h']
  # s.osx.exclude_files = ['Sources/Khala+UIKit.swift']
  # s.watchos.exclude_files = ['Sources/Khala+UIKit.swift']
  # s.tvos.exclude_files = ['Sources/Khala+UIKit.swift']

  s.dependency 'DarkTemplar', '0.0.1'
  s.requires_arc = true
end
