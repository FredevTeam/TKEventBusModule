//
//  TKEvent.swift
//  TKEventBusModule
//
//  Created by 聂子 on 2019/8/11.
//

import Foundation


public protocol TKEventProtocol {

}

extension Notification : TKEventProtocol {

}

extension TKEvent.Name {
    static var Association = TKEvent.Name.init("Association_Event")
}


public class TKEvent: TKEventProtocol {

    private(set) public var name: TKEvent.Name
    private(set) public var data: Any?

    public init(_ name: TKEvent.Name, data: Any?) {
        self.name = name
        self.data = data
    }
}


extension TKEvent {

    public struct Name: Hashable {
        private(set) var rawValue: String
        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }
    }
}
