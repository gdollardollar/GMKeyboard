Pod::Spec.new do |s|
  s.name             = 'GMKeyboard'
  s.version          = '0.1.0'
  s.summary          = 'Keyboard Handler'
  s.homepage         = 'https://github.com/gdollardollar/gmkeyboardhandler'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Guillaume Aquilina' => 'guillaume.aquilina@gmail.com' }
  s.source           = { :git => 'https://github.com/gdollardollar/gmkeyboardhandler.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*.swift'

end
