//
//  TKEventObserver.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation


// 观察序列对象
class TKEventObservable {
    var observers:[TKEventObserver] = []
}

extension TKEventObservable {
    func  setComplation(complation: @escaping Complation) {
        observers.forEach { (node) in
            if let node = node.obser as? TKIndependentEventObserverNode {
                node.complation = complation
            }
        }
    }

    func link()  {
        observers.forEach { (node) in
            if let obser = node.obser as? TKIndependentEventObserverNode {
                let eventNode = TKEventBus.instance.node(with: obser.eventName)
                if eventNode.observerList.find(by: node) == nil {
                    eventNode.observerList.append(node)
                }
            }
        }
        observers.removeAll()
    }
}

// 观察者
struct TKEventObserver: Equatable {
    var obser: ObserverNodeProtocol
    init(obser: ObserverNodeProtocol) {
        self.obser = obser
    }
}

extension TKEventObserver {
    static func == (lhs: TKEventObserver, rhs: TKEventObserver) -> Bool {
        if let lhs = lhs.obser as? TKIndependentEventObserverNode, let rhs = rhs.obser as? TKIndependentEventObserverNode {
            return lhs.uuid.uuidString == rhs.uuid.uuidString
        }
        if let lhs = lhs.obser as? TKAssociateEventObserverNode, let rhs = rhs.obser as? TKAssociateEventObserverNode {
            return lhs.uniqueIdentifier == rhs.uniqueIdentifier
        }
        return false
    }
}


extension TKEventObserver {
        // 系统通知，不发送通知
    func observer(event: TKEventProtocol, systemNotification: Bool = false) {
        if let node = obser as? TKIndependentEventObserverNode {
            node.complation?(event)
            guard systemNotification == false else { return }
//            if let systemNotification = event as? Notification {
//                NotificationCenter.default.post(systemNotification)
//            }
        }
    }
}

