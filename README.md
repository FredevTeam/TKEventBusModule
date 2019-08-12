# TKEventBusModule

[![CI Status](https://img.shields.io/travis/zhuamaodeyu/TKEventBusModule.svg?style=flat)](https://travis-ci.org/zhuamaodeyu/TKEventBusModule)
[![Version](https://img.shields.io/cocoapods/v/TKEventBusModule.svg?style=flat)](https://cocoapods.org/pods/TKEventBusModule)
[![License](https://img.shields.io/cocoapods/l/TKEventBusModule.svg?style=flat)](https://cocoapods.org/pods/TKEventBusModule)
[![Platform](https://img.shields.io/cocoapods/p/TKEventBusModule.svg?style=flat)](https://cocoapods.org/pods/TKEventBusModule)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TKEventBusModule is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TKEventBusModule'
```

## Example 
### 1. Subscriber

1. `Import`
```
import TKEventBusModule
```   

2. subscribe for NSObject subclass or add protocol `TKEventSubscriber` 

```
self.bus.subscribe(on: .login) { (event) in
    debugPrint("单独事件响应")
    debugPrint("测试时间：\(CACurrentMediaTime() - (self.start ?? 0))")
}

```

### 2. Publish. 
1. Create Event need name and data object.     

```
let event = TKEvent.init(.login, data: "事件1")

TKEventBus.instance.publish(event) 

```

#### Notification support 
```
let notification = Notification.init(name: .notification, object: "系统测试通知", userInfo: nil)
TKEventBus.instance.publish(notification)

```



## Author

zhuamaodeyu, playtomandjerry@gmail.com

## License

TKEventBusModule is available under the MIT license. See the LICENSE file for more info.
