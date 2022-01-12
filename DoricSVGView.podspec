Pod::Spec.new do |s|
    s.name             = 'DoricSVGView'
    s.version          = '0.1.0'
    s.summary          = 'Doric extension library for SVG'
  
    s.description      = <<-DESC
    Doric SVG plugin to load SVG.
                            DESC

    s.homepage         = 'https://github.com/doric-pub/DoricSVGView'
    s.license          = { :type => 'Apache-2.0', :file => 'LICENSE' }
    s.author           = { 'wushangkun' => 'shangkunwu@msn.com' }
    s.source           = { :git => 'https://github.com/doric-pub/DoricSVGView.git', :tag => s.version.to_s }
  
    s.ios.deployment_target = '9.0'
  
    s.source_files = 'iOS/Classes/**/*'
    s.resource     =  "dist/**/*"
    s.public_header_files = 'iOS/Classes/**/*.h'
    s.dependency 'DoricCore'
    s.dependency 'SDWebImageSVGKitPlugin'

end
