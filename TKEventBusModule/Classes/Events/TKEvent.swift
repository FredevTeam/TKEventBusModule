//
//  TKEvent.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation



/// 事件协议
/// 任意对象，通过实现此协议来适配消息总线
/// - Note:
///     默认情况下支持 Notification, 请直接使用 TKEvent 事件对象
public protocol TKEventProtocol {

    /// 事件名称
    var ename:TKEvent.Name {get set}
    
     /// 事件数据对象
    var data: Any? {get set}
    
    /// 事件数据对象 ---> JSON 字符串
    var jsonString: String? {get set}
}

extension Notification : TKEventProtocol {
   
    public var ename: TKEvent.Name {
        get {
            return TKEvent.Name.init(self.name.rawValue)
        }
        set {
            
        }
    }
    
    public var data: Any? {
        get {
            return self.userInfo == nil ? self.object : self.userInfo
        }
        set {
            
        }
    }
    
    /// Default nil, Notificaiton is not use, please dot use this property where self is notfication
    public var jsonString: String? {
        get {
            return nil
        }
        set {
            
        }
    }
}




extension TKEvent.Name {
    static var Association = TKEvent.Name.init("Association_Event")
}



/// 默认给出的事件对象
public class TKEvent: TKEventProtocol {

    
    public var ename: TKEvent.Name

   
    public var data: Any?

    
    public var jsonString: String?


    /// Event
    ///
    /// - Parameters:
    ///   - name: 名称
    ///   - data: 数据对象
    ///   - jsonString: data 编码的json 字符串
    /// - Note:
    ///     在涉及到组件化开发过程中，如果使用的是swift 进行开发，多组件通信需要 jsonString 部分内部，否则有可能无法进行数据类型转换
    public init(_ name: TKEvent.Name, data: Any?, jsonString: String? = nil) {
        self.ename = name
        self.data = data
        self.jsonString = jsonString
    }
}


extension TKEvent {
    ///    Name
    public struct Name: Hashable {
        private(set) var rawValue: String
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }
}
