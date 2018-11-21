//
//  Message.swift
//  Messages
//
//  Created by Jonathan on 11/15/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import Foundation

class Message: NSObject {
    var fromId:String?
    var text:String?
    var timestamp:NSNumber?
    var toId:String?
    
    init(dictionary:[String:Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
    }
}
