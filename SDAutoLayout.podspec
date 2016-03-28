Pod::Spec.new do |s|

  s.name         = "SDAutoLayout"
  s.version      = "1.50"
  s.summary      = "The most easy way for autoLayout. Based Runtime.    1.50版本更新内容：升级了缓存机制，新版本在tableview滑动cell时候流畅度和性能提升20%以上"

  s.homepage     = "https://github.com/gsdios/SDAutoLayout"
  # s.screenshots  = "https://camo.githubusercontent.com/5d9e879c7006297b3d6e12c20c6cd1e15bf83016/687474703a2f2f7777332e73696e61696d672e636e2f626d6964646c652f39623831343665646777316578346d756b69787236673230396730376c6864742e676966"

  s.license      = "MIT"

  s.author             = { "GSD_iOS" => "gsdios@126.com" }

  s.platform     = :ios
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/gsdios/SDAutoLayout.git", :tag => "1.50"}

  s.source_files  = "SDAutoLayoutDemo/SDAutoLayout/**/*.{h,m}"

  # s.public_header_files = "Classes/**/*.h"


  s.requires_arc = true

   # s.dependency "JSONKit", "~> 1.4"

end
