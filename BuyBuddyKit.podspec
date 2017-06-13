#
#  Be sure to run `pod spec lint BuyBuddyKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "BuyBuddyKit"
  s.version      = "1.0.0"
  s.summary      = "BuyBuddyKit is a SDK that enables your app to connect and use the buybuddy system."
  s.description  = "BuyBuddyKit is a SDK that contains all the neccesary views and http call methods for you to connect to the BuyBuddy system and enable your customers the interface and the capabilities to use the BuyBuddy shopping experience."
  s.homepage     = "http://buybuddy.co"
  s.author             = { "eciftcioglu" => "emir@buybuddy.co" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/heybuybuddy/BuyBuddyKit", :tag => s.version}
  s.ios.deployment_target = '9.0'
  s.ios.vendored_frameworks = 'BuyBuddyKit.framework'
  s.module_name = 'BuyBuddyKit'


end
