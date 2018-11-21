//
//  User.swift
//  Messages
//
//  Created by Jonathan on 11/9/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import Foundation
import RealmSwift

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var profileImageURL:String?
    init(dictionary: [String:Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}

// Saved Data
class UserData: Object {
    @objc dynamic var name:String?
    @objc dynamic var email:String?
}

