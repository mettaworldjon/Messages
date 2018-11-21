//
//  FirebaseDataManager.swift
//  Messages
//
//  Created by Jonathan on 11/10/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDataManager {
    private init() {}
    
    static let shared = FirebaseDataManager()
    
    enum fetchType {
        case uid
        case email
        case displayName
    }
    
    func getCurrentUser(fetchType:fetchType) -> String {
        switch fetchType {
        case .displayName:
            return Auth.auth().currentUser?.displayName ?? ""
        default:
            return "Shit Happens"
        }
    }
}
