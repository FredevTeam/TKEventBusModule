//
//  TKEventSubscriber.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation


public protocol TKEventSubscriber {
    associatedtype Subscriber
    var bus: Subscriber { get }
    static var bus:Subscriber.Type { get }
}

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

public class EventSubscriberMaker<T> : EventSubscriberProtocol {
    public let wrappedValue: T

    var observable: TKEventObservable = TKEventObservable()

    public required init(value: T) {
        self.wrappedValue = value
    }
}
extension NSObject : TKEventSubscriber {}
