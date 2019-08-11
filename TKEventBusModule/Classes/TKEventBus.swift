//
//  TKEventBus.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation

public class TKEventBus {
    public static let instance =  TKEventBus.init()

    let queue = DispatchQueue.init(label: "com.tkeventbus", qos: .default, attributes: [])
    var eventList: LinkedList = LinkedList<TKEventNode>.init()

    private init() {
        eventList.append(TKEventNode.init(.Association, event: nil))
    }
}

