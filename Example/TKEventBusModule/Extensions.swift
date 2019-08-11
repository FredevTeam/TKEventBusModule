//
//  Extensions.swift
//  TKEventBusModule_Example
//
//  Created by 聂子 on 2019/8/11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import TKEventBusModule 

struct Present {

}

extension TKEvent.Name {
    static var login = TKEvent.Name.init("login")
    static var update = TKEvent.Name.init("update")
    static var logout = TKEvent.Name.init("logout")
    static var clear = TKEvent.Name.init("clear")
}
extension Notification.Name {
    static var notification = Notification.Name.init("Notification")
}

