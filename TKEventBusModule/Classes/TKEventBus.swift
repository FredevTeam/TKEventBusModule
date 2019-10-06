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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - 系统通知处理
extension TKEventBus {
    func addNotificationObserver(name: Notification.Name, object: AnyObject) {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationAction(notification:)), name: name, object: nil)
    }
    @objc func notificationAction(notification: Notification) {
        TKEventBus.instance.sendEvent(event: notification, systemNotification: true)
    }
    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self , name: name, object: nil)
    }
}
