//
//  TKEventSubscriber.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation



/// 订阅者协议(命名空间协议)
public protocol TKEventSubscriber {
    associatedtype Subscriber
    var bus: Subscriber { get }
    static var bus:Subscriber.Type { get }
}

// MARK: - 命名空间协议
public extension TKEventSubscriber {
    var bus: EventSubscriberMaker<Self> {
        return EventSubscriberMaker(value: self)
    }
    static var bus: EventSubscriberMaker<Self>.Type {
        return EventSubscriberMaker.self
    }
}

public protocol EventSubscriberProtocol {
    associatedtype WrappedType
    var wrappedValue : WrappedType { get }
    init(value : WrappedType)
}

/// 订阅者
public class EventSubscriberMaker<T> : EventSubscriberProtocol {
    public let wrappedValue: T

    var observable: TKEventObservable = TKEventObservable()

    public required init(value: T) {
        self.wrappedValue = value
    }
}

// MARK: - TKEventSubscriber 任意 NSObject 对象都可作为订阅者
extension NSObject : TKEventSubscriber {}
