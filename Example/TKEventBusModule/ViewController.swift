//
//  ViewController.swift
//  TKEventBusModule
//
//  Created by zhuamaodeyu on 08/11/2019.
//  Copyright (c) 2019 zhuamaodeyu. All rights reserved.
//

import UIKit
import TKEventBusModule


class ViewController: UIViewController {

    private var start : TimeInterval?
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeOneEvent()
        subscribeNotificationEvent()
        subscribeMoreEvent()
        subscribeFusionEvents()
    }
}


// MARK: - UI Action 
extension ViewController {
    @IBAction func oneEventSendAction(_ sender: Any) {
        start = CACurrentMediaTime()
        TKEventBus.instance.publish(TKEvent.init(.login, data: "这是个单独测试事件"))
    }
    @IBAction func moreEventSendAction(_ sender: Any) {
         start = CACurrentMediaTime()
        TKEventBus.instance.publish(TKEvent.init(.login, data: "事件1"))
        TKEventBus.instance.publish(TKEvent.init(.update, data: "事件2"))
    }

    @IBAction func FusionEventSendAction(_ sender: Any) {
         start = CACurrentMediaTime()
        TKEventBus.instance.publish(TKEvent.init(.login, data: "事件1"))
        TKEventBus.instance.publish(TKEvent.init(.logout, data: "事件2"))
    }

    @IBAction func notificationEventSendAction(_ sender: Any) {
         start = CACurrentMediaTime()
        TKEventBus.instance.publish(Notification.init(name: .notification, object: "系统测试通知", userInfo: nil))
    }


    @IBAction func cancelSubscribeTKEvent(_ sender: Any) {
        self.bus.unsubscribe(on: .login, fusion: true)
    }

    @IBAction func cancelSubscribeNotificaiton(_ sender: Any) {
        self.bus.unsubscribe(on: .notification)
    }

    @IBAction func randomSendEvent(_ sender: Any) {
        let random = arc4random() % 10000
        TKEventBus.instance.publish(TKEvent.init(TKEvent.Name.init("\(random)"), data: "\(random)"))
    }
}

// MARK: - Subscribe
extension ViewController {
    private func subscribeOneEvent() {
        self.bus.subscribe(on: .login) { (event) in
            debugPrint("单独事件响应")
            debugPrint("测试时间：\(CACurrentMediaTime() - (self.start ?? 0))")
        }
    }
    private func subscribeNotificationEvent() {
        self.bus.subscribe(on: .notification) { (event) in
            debugPrint("通知兼容响应")
            debugPrint("测试时间：\(CACurrentMediaTime() - (self.start ?? 0))")
        }
    }

    private func subscribeMoreEvent() {
        self.bus.subscribe(on: .login).subscribe(on: .update) { (event) in
            debugPrint("响应互斥事件\(event)")
            debugPrint("测试时间：\(CACurrentMediaTime() - (self.start ?? 0))")
        }
    }

    private func subscribeFusionEvents() {
        self.bus.subscribe([.login,.logout]) { (events) in
            debugPrint("监听融合事件\(String(describing: events?.count))")
            debugPrint("测试时间：\(CACurrentMediaTime() - (self.start ?? 0))")
        }
    }
}


// MARK: - Publish
extension ViewController {

    /// 正常
    private func observerMoreEvent() {
        // 任意一个都会调用block
        self.bus.subscribe(on: .login).subscribe(on: .update) { (event) in
            if let event = event as? TKEvent {
                debugPrint("\(String(describing: event.data))")
            }
        }
    }


    private func consolidationEvent() {
        // 所有事件接收完毕才会调用block
        self.bus.subscribe([.login, .update]) { (events) in
            debugPrint("触发融合事件")
        }
    }

    private func notificationEvent() {
        self.bus.subscribe(on: .notification) { (event) in
            debugPrint("通知\(event)")
        }
    }



    private func notificationsEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(noticication(_:)), name: .notification, object: nil)
    }
}

extension ViewController {
    private func otherObjectObserverEvent() {

    }

    @objc private func noticication(_ notification: Notification) {
        debugPrint("\(String(describing: notification.object))")
    }

}
