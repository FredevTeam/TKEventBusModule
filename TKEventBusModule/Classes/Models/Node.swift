//
//  Node.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation



protocol ObserverNodeProtocol {
    var uuid: UUID { get set }
}


class TKEventNode {

    var name: TKEvent.Name
    var event: TKEventProtocol?
    var observerList = LinkedList<TKEventObserver>.init()

    init(_ name: TKEvent.Name, event: TKEventProtocol?) {
        self.name = name
        self.event = event
    }
}

extension TKEventNode : Equatable {
    static func == (lhs: TKEventNode, rhs: TKEventNode) -> Bool {
        return lhs.name.rawValue == rhs.name.rawValue
    }
}


class TKIndependentEventObserverNode:ObserverNodeProtocol {
    var uuid: UUID


    var eventName:TKEvent.Name
    var complation:Complation?
    private(set) weak var target: AnyObject?

    init(eventName:TKEvent.Name, complation:Complation? = nil, target: AnyObject? = nil) {
        self.uuid = UUID.init()
        self.eventName = eventName
        self.complation = complation
        self.target = target
    }
}

class TKAssociateEventObserverNode: ObserverNodeProtocol {
    var uuid: UUID
    private(set) var uniqueIdentifier: String?
    var events:[TKEvent.Name:TKEventProtocol] = [:]
    var eventNames:[TKEvent.Name] = [] {
        didSet {
            let strings = eventNames.map { (name) -> String in
                return name.rawValue
            }
            uniqueIdentifier = strings.sorted().joined(separator: "_").md5()
        }
    }
    var complation:MoreEventComplation?
    weak var target: AnyObject?

    init(target: AnyObject?) {
        self.uuid = UUID.init()
        self.target = target
    }
}


