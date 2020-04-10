Pod::Spec.new do |s|
  s.name = 'Gist'
  s.version = '0.0.2'
  s.summary = 'Gist'
  s.description = 'In-app messaging that converts'
  s.homepage = 'https://gist.build'
  s.license = { :type => 'Bourbon Platform License', :file => 'LICENSE' }
  s.author = 'Bourbon Ltd'
  s.swift_version = '5.0'

  s.ios.deployment_target = '10.0'

  s.source = { :git => 'https://gitlab.com/bourbonltd/gist-apple', :tag => s.version }

  s.source_files  = 'Gist/*.{swift,h,m}', 'Gist/**/*.{swift,h,m}'
  s.dependency 'BourbonEngine', '~> 0.0.9'
  s.dependency 'Alamofire', '~> 5.1'
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'armv7 arm64 x86_64' }
end
