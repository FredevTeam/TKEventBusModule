//
//  TKEventSubscriber+Subscriber.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation




/// 普通事件回调 block
public typealias Complation = ((_ event: TKEventProtocol) -> Void)

/// 融合事件回调 block
public typealias MoreEventComplation = ((_ event: [TKEventProtocol]?) -> Void)


// MARK: - 订阅
extension EventSubscriberMaker {

    /// 订阅事件
    ///
    /// - Parameters:
    ///   - name: 事件名
    ///   - complation: 回调
    /// - Returns: 订阅者
    /// - Example:
    ///
    ///     ```
    ///     self.bus.subscribe(on: .login) { (event) in
    ///         debugPrint("测试时间：\(CACurrentMediaTime() - (self.start ?? 0))")
    ///     }
    ///     // 链式调用，多个事件触发同一个回调，(互斥),接收到每个事件都会触发当前回调，可以在回调内部做判断区别 响应事件
    ///     self.bus.subscribe(on: .login).subscribe(on: .update) { (event) in
    ///
    ///         // do some thing
    ///     }
    ///     ```
    ///
    ///
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
    /// - Example:
    ///
    ///     ```
    ///     self.bus.subscribe(on: .notification) { (event) in
    ///
    ///         do some thing
    ///     }
    ///     ```
    @discardableResult
    public func subscribe(on name:Notification.Name, complation:Complation? = nil) -> Self {
        
        TKEventBus.instance.addNotificationObserver(name: name, object: self.wrappedValue as AnyObject)
        return subscribe(on: TKEvent.Name.init(name.rawValue), complation: complation)
    }


    /// 合并订阅多个事件(融合订阅)
    ///
    /// 将多个事件合并为一个可事件回调，当满足所有的事件时，才会触发回调
    /// - Parameters:
    ///   - events: 事件
    ///   - complation: 事件回调
    /// - Returns: observer
    /// - Example:
    ///
    ///     ```
    ///     self.bus.subscribe([.login,.logout]) { (events) in
    ///         /// do some thing
    ///     }
    ///     ```
    /// - Note:
    ///     合并多个事件，及将当前给定的 `events` 多个事件合并为一个事件回调， 只有满足所有的事件时，才会触发回调
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
// MARK: - Pause/ restore
extension EventSubscriberMaker {


    /// 暂停订阅
    ///
    /// 此方法推荐在 viewWillDisappear 等方法中调用，及当前暂时不想接收此事件的的地方调用
    /// - Parameter name: 事件名称
    /// - Returns: self
    /// - Precondition:
    ///     此方法需要在已经订阅事件后才有效，未订阅事件调用无效
    /// - Note:
    ///     此方法不会取消事件监听，只是暂停
    /// - Precondition:
    ///     此方法 暂时不支持 联合事件
    ///
    @discardableResult
    public func pauseSubscribe(on name: TKEvent.Name) -> Self {
        let extendObserver = ExtendObserverNode.init(name: name, observer: self.wrappedValue as AnyObject)
        if !TKEventBus.instance.extendObservers.contains(where: { (n) -> Bool in
            n == extendObserver
        }) {
            TKEventBus.instance.extendObservers.append(extendObserver)
        }
        return self
    }


    /// 恢复订阅
    ///
    /// 当想恢复此事件监听时，可以调用此方法，
    /// - Parameter name: 事件名称
    /// - Returns: Self
    /// - Note:
    ///     此方法不会导致订阅，如果当前事件未订阅， 将不会触发订阅操作
    /// - Precondition:
    ///     此方法 暂时不支持 联合事件
    ///
    @discardableResult
    public func restoreSubscribe(on name: TKEvent.Name) -> Self {
        let extendObserver = ExtendObserverNode.init(name: name, observer: self.wrappedValue as AnyObject)
        let filters = TKEventBus.instance.extendObservers.filter { (n) -> Bool in
            n == extendObserver
        }
        TKEventBus.instance.extendObservers.removeAll { (m) -> Bool in
            filters.contains(m)
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
        TKEventBus.instance.removeNotificationObserver(name: name)
        unsubscribe(on: TKEvent.Name.init(name.rawValue), target: self.wrappedValue as AnyObject)
        return self
    }


    /// 取消订阅融合类型事件
    ///
    /// - Parameters:
    ///   - name: 事件名称
    ///   - fusion: 是否取消包含此事件的融合事件
    ///             默认情况下，只会去除融合事件中关于此事件的内容， true: 会整个删除包含此事件的融合事件订阅
    ///             default: false
    /// - Returns: 订阅者
    /// - Example:
    ///
    ///     ```
    ///         self.bus.ubsubscribe(on: .login, fusion: true)
    ///
    ///
    ///     ```
    /// - Note:
    ///     默认情况下, `fusion`是false的， 取消订阅当前事件，不会影响到联合订阅部分，如果 `fusion`是true,当联合事件中包含此事件时，将不会触发事件回调，及也取消了联合事件订阅
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

