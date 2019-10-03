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

}

extension Notification : TKEventProtocol {

}

extension TKEvent.Name {
    static var Association = TKEvent.Name.init("Association_Event")
}



/// 默认给出的事件对象
public class TKEvent: TKEventProtocol {


    /// 事件名称
    private(set) public var name: TKEvent.Name

    /// 事件数据对象
    private(set) public var data: Any?

    /// 事件数据对象 ---> JSON 字符串
    private(set) public var jsonString: String?


    /// Event
    ///
    /// - Parameters:
    ///   - name: 名称
    ///   - data: 数据对象
    ///   - jsonString: data 编码的json 字符串
    /// - Note:
    ///     在涉及到组件化开发过程中，如果使用的是swift 进行开发，多组件通信需要 jsonString 部分内部，否则有可能无法进行数据类型转换
    public init(_ name: TKEvent.Name, data: Any?, jsonString: String? = nil) {
        self.name = name
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
