#
Pod::Spec.new do |s|

s.name            = "HHPhotoBrowser"

s.version          = "1.0.0"

s.summary          = "A photobrowser used on iOS by OC."

s.description      = <<-DESC

It is a photobrowser which implement by Objective-C.

DESC

s.homepage        = "https://github.com/NIHui1011/HHPhotoBrowerDemo"

# s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"

s.license          = 'GPL'

s.author          = { "NIHui1011" => "416824366@qq.com" }

s.source          = { :git => "https://github.com/NIHui1011/HHPhotoBrowser.git", :tag => "1.0.0" }

# s.social_media_url = 'https://twitter.com/NAME'

s.platform    = :ios, '7.0'

# s.ios.deployment_target = '5.0'

# s.osx.deployment_target = '10.7'

s.requires_arc = true

s.source_files = 'HHPhotoBrowserDemo/HHPhotoBrowser/*'

# s.resources = 'Assets'

# s.ios.exclude_files = 'Classes/osx'

# s.osx.exclude_files = 'Classes/ios'

# s.public_header_files = 'Classes/**/*.h'

s.frameworks = 'Foundation', 'UIKit'

end
