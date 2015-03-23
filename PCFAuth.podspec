Pod::Spec.new do |s|
  s.name     = 'PCFAuth'
  s.version  = '1.0.0'
  s.license  = { :type => 'CUSTOM', :file => 'LICENSE' }
  s.summary  = 'PCF Mobile Services Auth Client SDK for iOS'
  s.homepage = 'https://github.com/cfmobile'
  s.authors  = 'Joshua Winters, Devin Fallak, Andrew Wright'
  s.source   = { :git => 'https://github.com/cfmobile/auth-ios.git', :tag => "v1.0.0" }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'

  s.public_header_files = 'PCFAuth/**/*.h'
  s.source_files = 'PCFAuth/**/*.{h,m}'
end
