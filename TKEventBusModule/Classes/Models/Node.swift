//
//  Node.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation



protocol ObserverNodeProtocol {
    var uuid: UUID { get set }
    func contain(event name: TKEvent.Name, target: AnyObject) -> Bool
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
    func contain(event name: TKEvent.Name, target: AnyObject) -> Bool {
        if let selfT = self.target {
            if name.rawValue == eventName.rawValue && Unmanaged.passUnretained(target).toOpaque() == Unmanaged.passUnretained(selfT).toOpaque() {
                return true
            }
        }
        return false
    }

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
    func contain(event name: TKEvent.Name, target: AnyObject) -> Bool {
        if let selfT = self.target {
            let hasName = Array(events.keys).contains { (n) -> Bool in
                n.rawValue == name.rawValue
            }
            if hasName && Unmanaged.passUnretained(target).toOpaque() == Unmanaged.passUnretained(selfT).toOpaque() {
                return true
            }
        }
        return false
    }

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


/// 排除对象
class ExtendObserverNode {
    var name: TKEvent.Name
    weak var observer: AnyObject?
    init(name: TKEvent.Name, observer: AnyObject?) {
        self.name = name
        self.observer = observer
    }
}
extension ExtendObserverNode: Equatable {
    static func == (lhs: ExtendObserverNode, rhs: ExtendObserverNode) -> Bool {
        if let lhsO = lhs.observer, let rhsO = rhs.observer {
            return lhs.name.rawValue == rhs.name.rawValue && Unmanaged.passUnretained(lhsO).toOpaque() == Unmanaged.passUnretained(rhsO).toOpaque()
        }
        return false

    }


}
