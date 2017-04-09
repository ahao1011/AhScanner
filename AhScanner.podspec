

Pod::Spec.new do |s|
  s.name         = 'AhScanner'
  s.version      = '0.1.1'
  s.ios.deployment_target = '8.0'
  s.summary      = 'A tool for ID card identification by 阿浩'
  s.homepage     = 'https://github.com/ahao1011/AhScanner'
  s.license      = 'MIT'
  s.author       = { 'ah'=> 'zth1011@126.com'}
  s.source       = { :git => 'https://github.com/ahao1011/AhScanner.git', :tag => s.version.to_s}
  s.source_files = 'AhScanner','AhScanner/*.{h,m}'
  #s.public_header_files = 'AhScannerHeader/*.h'
  s.frameworks = 'AVFoundation', 'AssetsLibrary'
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true
  `echo "2.3" > .swift-version`

end
