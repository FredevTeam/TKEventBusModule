//
//  TKEventBus.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation

/// 事件总线
///  用来统一管理，调度事件 
public class TKEventBus {
    /// 单利
    public static let instance =  TKEventBus.init()

    let queue = DispatchQueue.init(label: "com.tkeventbus", qos: .default, attributes: [])
    var eventList: LinkedList = LinkedList<TKEventNode>.init()
    // 暂时剔除监听者对象数组
    var extendObservers:[ExtendObserverNode] = []

    private init() {
        eventList.append(TKEventNode.init(.Association, event: nil))
    }
}

