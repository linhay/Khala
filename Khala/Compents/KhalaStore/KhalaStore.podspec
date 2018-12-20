Pod::Spec.new do |s|
s.name             = 'KhalaStore'
s.version          = '0.1.0'
s.summary          = 'KhalaStore'

s.homepage         = 'https://github.com/linhay/Routable'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'linhey' => 'is.linhay@outlook.com' }
s.source = { :git => 'https://github.com/linhay/khala.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = ["Sources/*/**","Sources/*/*/**","Sources/**"]

s.frameworks = ['UIKit']
s.requires_arc = true
s.dependency 'Khala'

end
