//
//  SecondViewController.swift
//  TKEventBusModule_Example
//
//  Created by 聂子 on 2019/10/3.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import TKEventBusModule


class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bus.subscribe(on: .login) { (event) in
            debugPrint("SecondViewController 单独事件响应")
        }
    }

    @IBAction func sendEventAction(_ sender: Any) {
         TKEventBus.instance.publish(TKEvent.init(.login, data: "这是个单独测试事件"))
    }
}
