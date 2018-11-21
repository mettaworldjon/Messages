//
//  RealmDataManager.swift
//  Messages
//
//  Created by Jonathan on 11/9/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataManager {
    
    private init() {}
    
    static let shared = RealmDataManager()
    
    var realm = try! Realm()
    
    func insertUserLocal(User:UserData) {
        do {
            try realm.write {
                realm.add(User)
            }
        } catch let err {
            print(err)
        }
    }
    
    func deleteUserLocal(User:Results<UserData>) {
        do {
            try realm.write {
                realm.delete(User)
            }
        } catch let err {
            print(err)
        }
    }
}

