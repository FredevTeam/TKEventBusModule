//
//  TKEventBus+Publish.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation

extension TKEventBus {

    /// publish
    ///
    /// - Parameter event: event
    public func publish(_ event: TKEventProtocol) {
        append(event: event)
        sendEvent(event: event)
    }
}



// MARK: - private
extension TKEventBus {
    private func sendEvent(event: TKEventProtocol) {

        guard let newNode = eventProtocolToEventNode(event: event) else {
            return
        }
        let node = eventList.find(by: newNode)
        let assNode = eventList.find(by: TKEventNode.init(.Association, event: nil))

        queue.async {
            for item in node?.value.observerList.toArray() ?? [] {
                // 调用回调
                if let observer = item.obser as? TKIndependentEventObserverNode {
                    if observer.target != nil {
                        item.observer(event:event)
                    }else {
                        node?.value.observerList.removes(at: [item])
                    }
                }
            }
        }
        queue.async {
            let assObservers = assNode?.value.observerList.toArray() ?? []
            let result = assObservers.filter({ (observer) -> Bool in
                if let ob = observer.obser as? TKAssociateEventObserverNode {
                    return ob.eventNames.contains(newNode.name)
                }
                return false
            })
            result.forEach({ (ob) in
                if let observer = ob.obser as? TKAssociateEventObserverNode {
                    observer.events.updateValue(event, forKey: newNode.name)
                    if observer.events.keys.count == observer.eventNames.count {
                        if observer.target != nil {
                            observer.complation?(Array(observer.events.values))
                            observer.events.removeAll()
                        }else {
                            assNode?.value.observerList.removes(at: [ob])
                        }
                    }
                }
            })
        }

    }
}

// MARK: - List
extension TKEventBus {
    // append
    private func append(event: TKEventProtocol){
        if let node = eventProtocolToEventNode(event: event) {
            if eventList.contains(node) {
                return
            }
            eventList.append(node)
        }
    }


    // node
    func node(with name: TKEvent.Name) -> TKEventNode {
        let n = TKEventNode.init(name, event: nil)

        if let node = eventList.find(by: n) {
            return node.value
        }
        eventList.append(n)
        return n
    }

    // event ----> TKEventNode
    private func eventProtocolToEventNode(event: TKEventProtocol) -> TKEventNode? {
        var node:TKEventNode?
        if let notification = event as? Notification {
            node = TKEventNode.init(TKEvent.Name.init(notification.name.rawValue), event: notification)
        }
        if let e = event as? TKEvent {
            node = TKEventNode.init(TKEvent.Name.init(e.name.rawValue), event: e)
        }
        return node
    }
}