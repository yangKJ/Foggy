Pod::Spec.new do |s|
  s.name     = "Foggy"
  s.version  = "1.0.3"
  s.summary  = "Exception handling tool"
  s.homepage = "https://github.com/yangKJ/Foggy"
  s.license  = "MIT"
  s.author   = {"77" => "ykj310@126.com"}
  s.platform = :ios
  s.source   = {:git => "https://github.com/yangKJ/Foggy.git",:tag => "#{s.version}"}
  s.requires_arc = true
  s.source_files = 'Foggy/Exception/**/*.{h,m}'
  
end
