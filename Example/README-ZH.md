
# TKEventBusModule

[![CI Status](https://img.shields.io/travis/zhuamaodeyu/TKEventBusModule.svg?style=flat)](https://travis-ci.org/zhuamaodeyu/TKEventBusModule)
[![Version](https://img.shields.io/cocoapods/v/TKEventBusModule.svg?style=flat)](https://cocoapods.org/pods/TKEventBusModule)
[![License](https://img.shields.io/cocoapods/l/TKEventBusModule.svg?style=flat)](https://cocoapods.org/pods/TKEventBusModule)
[![Platform](https://img.shields.io/cocoapods/p/TKEventBusModule.svg?style=flat)](https://cocoapods.org/pods/TKEventBusModule)

## 安装示例

添加/创建 `Podfile` 文件，并添加`pod 'TKEventBusModule'`, 然后执行 `pod install` 以安装


## Example 
### 1. Subscriber(订阅者)

1. `Import`
```
import TKEventBusModule
```   

2. 默认 NSObject 的所有子类都实现了 `TKEventSubscriber`  协议，成为订阅者

```
self.bus.subscribe(on: .login) { (event) in
    debugPrint("单独事件响应")
    debugPrint("测试时间：\(CACurrentMediaTime() - (self.start ?? 0))")
}

```
3. 自定义订阅者

```
struct Present: TKEventSubscriber {

}
private var present = Present() 

present.bus.subscribe(on: .login) { (event) in
debugPrint("单独事件响应")
debugPrint("测试时间：\(CACurrentMediaTime() - (self.start ?? 0))")
}
```
#### 暂停/ 重启

1. 暂停订阅

```
self.bus.pauseSubscribe(on: .login)

```
2. 重启订阅

```
self.bus.restoreSubscribe(on: .login)

```


### 2. 发布 
1.  创建一个事件，默认必须 name 和 data 属性

```
let event = TKEvent.init(.login, data: "事件1", jsonString:"")

TKEventBus.instance.publish(event) 

```
__Note:__如果项目采用了组件化开发，并且基于 swift 语言实现，需要通过  `init(_ name: , data:, jsonString:)` 方式来初始化


##### 系统通知支持
```
let notification = Notification.init(name: .notification, object: "系统测试通知", userInfo: nil)
TKEventBus.instance.publish(notification)

```
__Note:__ 当兼容系统通知时， `jsonString` 属性无效，并且 data 属性默认返回 object 或者 userInfo 数据




## Author

zhuamaodeyu, playtomandjerry@gmail.com

## License

TKEventBusModule is available under the MIT license. See the LICENSE file for more info.
