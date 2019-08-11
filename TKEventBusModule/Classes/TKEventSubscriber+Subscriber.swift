//
//  TKEventSubscriber+Subscriber.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation



public typealias Complation = ((_ event: TKEventProtocol) -> Void)
public typealias MoreEventComplation = ((_ event: [TKEventProtocol]?) -> Void)


// MARK: - 订阅
extension EventSubscriberMaker {

    /// 订阅事件
    ///
    /// - Parameters:
    ///   - name: 事件名
    ///   - complation: 回调
    /// - Returns: 订阅者
    @discardableResult
    public func subscribe(on name: TKEvent.Name, complation:Complation? = nil) -> Self {
        // complation = nil
        let observer = TKEventObserver.init(obser: TKIndependentEventObserverNode.init(eventName: name, complation: complation, target: self.wrappedValue as AnyObject))
        observable.observers.append(observer)
        if let complation = complation {
            observable.setComplation(complation: complation)
            observable.link()
            return self
        }
        return self
    }


    /// 订阅通知类型事件
    ///
    /// - Parameters:
    ///   - name: 通知名称
    ///   - complation: 回调
    /// - Returns: 订阅者
    @discardableResult
    public func subscribe(on name:Notification.Name, complation:Complation? = nil) -> Self {
        return subscribe(on: TKEvent.Name.init(name.rawValue), complation: complation)
    }


    /// 合并订阅多个事件
    ///
    /// - Parameters:
    ///   - event: 事件
    /// - Returns: observer
    @discardableResult
    public func subscribe(_ events:[TKEvent.Name], complation:@escaping MoreEventComplation) -> Self {
        let node = TKAssociateEventObserverNode.init(target: self.wrappedValue as AnyObject)
        node.eventNames.append(contentsOf: events)
        node.complation = complation
        let observer = TKEventObserver.init(obser: node)
        // 联合事件
        let eventNode = TKEventBus.instance.node(with: .Association)
        if eventNode.observerList.find(by: observer) == nil {
            eventNode.observerList.append(observer)
        }
        return self
    }
}



// MARK: - Unsubscribe
extension EventSubscriberMaker {

    /// 取消订阅
    ///
    /// - Parameter name: 事件名称
    /// - Returns: 订阅者
    @discardableResult
    public func unsubscribe(on name: TKEvent.Name) -> Self {
        unsubscribe(on: name, target: self.wrappedValue as AnyObject)
        return self
    }

    /// 取消通知类型事件订阅
    ///
    /// - Parameter name: 通知名称
    /// - Returns: 订阅者
    @discardableResult
    public func unsubscribe(on name: Notification.Name) -> Self {
        unsubscribe(on: TKEvent.Name.init(name.rawValue), target: self.wrappedValue as AnyObject)
        return self
    }


    /// 取消订阅融合类型事件
    ///
    /// - Parameters:
    ///   - name: 事件名称
    ///   - fusion: 是否取消包含此事件的融合事件
    ///             默认情况下，只会去除融合事件中关于此事件的内容， true: 会整个删除包含此事件的融合事件订阅
    /// - Returns: 订阅者
    @discardableResult
    public func unsubscribe(on name: TKEvent.Name, fusion: Bool = false) -> Self {
        unsubscribe(on: name, target: self.wrappedValue as AnyObject, fusion: fusion)
        return self
    }
}


// MARK: - private
extension EventSubscriberMaker {

    private func unsubscribe(on name: TKEvent.Name, target: AnyObject, fusion: Bool = false) {
        // 删除单独事件
        let eventNode = TKEventBus.instance.node(with: name)
        let observers =  eventNode.observerList.toArray().filter { (observer) -> Bool in
            if let observer = observer.obser as? TKIndependentEventObserverNode {
                if let obt = observer.target {
                    return Unmanaged.passUnretained(obt).toOpaque() == Unmanaged.passUnretained(target).toOpaque()
                }
            }
            return false
        }
        eventNode.observerList.removes(at: observers)

        // 删除融合事件
        let feventNode = TKEventBus.instance.node(with: .Association)
        let fobservers = feventNode.observerList.toArray().filter { (observer) -> Bool in
            if let observer = observer.obser as? TKAssociateEventObserverNode, let obt = observer.target {
                return (Unmanaged.passUnretained(obt).toOpaque() == Unmanaged.passUnretained(target).toOpaque()) && observer.eventNames.contains(name)
            }
            return false
        }
        if fusion {
            feventNode.observerList.removes(at: fobservers)
        }else {
            fobservers.forEach { (observer) in
                if let observer = observer.obser as? TKAssociateEventObserverNode {
                    observer.eventNames.removeAll(where: { (n) -> Bool in
                        n.rawValue == name.rawValue
                    })
                }
            }
        }
    }
}

