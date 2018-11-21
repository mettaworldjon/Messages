//
//  MessagesController.swift
//  Messages
//
//  Created by Jonathan on 11/6/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class MessagesController: UITableViewController {
    
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        checkIfUserLoggedIn()
        observeUserMessages()
        registerCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchRealmData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserLoggedIn()
    }
    
    fileprivate func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "new_message_icon"), style: .plain, target: self, action: #selector(handleNewMessage))
    }
    
    fileprivate func fetchRealmData() {
        let data = RealmDataManager.shared.realm.objects(UserData.self)
        if data.count > 0 {
            self.navigationItem.title = data[0].name
            let button = UIButton(type: .system)
            button.setTitle(data[0].name, for: .normal)
            button.addTarget(self, action: #selector(showChatController), for: .touchUpInside)
            self.navigationItem.titleView = button
        }
    }
    
    fileprivate func handleMesssageData(_ snapshot: (DataSnapshot)) {
        if let dictionary = snapshot.value as? [String:AnyObject] {
            // Study
            let message = Message(dictionary: dictionary)
            if let toId = message.toId {
                self.messagesDictionary[toId] = message
                self.messages = Array(self.messagesDictionary.values)
                self.messages.sort(by: { (m1, m2) -> Bool in
                    return m1.timestamp!.int32Value > m2.timestamp!.int32Value
                })
            }
            
        }
    }
    
    fileprivate func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded) { (snapshot) in
            let messageKey = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageKey)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                self.handleMesssageData(snapshot)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
            
        }
        
    }
    
    fileprivate func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded) { (DataSnapshot) in
            if let dictionary = DataSnapshot.value as? [String:AnyObject] {
                // Study
                let message = Message(dictionary: dictionary)
                if let toId = message.toId {
                    self.messagesDictionary[toId] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort(by: { (m1, m2) -> Bool in
                        return m1.timestamp!.int32Value > m2.timestamp!.int32Value
                    })
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    fileprivate func checkIfUserLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else if let safeUID = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users").child(safeUID).observe(.value, with: { (DataSnapshot) in
                if let data = DataSnapshot.value as? [String:AnyObject] {
                    self.setupNavWithUser(user: User(dictionary: data))
                }
                
            }, withCancel: nil)
        }
    }
    
    fileprivate func setupNavWithUser(user:User) {
        self.messages.removeAll()
        self.messagesDictionary.removeAll()
        let button = UIButton(type: .system)
        button.setTitle(user.name, for: .normal)
        self.navigationItem.titleView = button
    }

    @objc func showChatController(user:User) {
        let layout = UICollectionViewFlowLayout()
        let chatLogController = ChatLogController(collectionViewLayout: layout)
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }

    @objc fileprivate func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let toDelete = RealmDataManager.shared.realm.objects(UserData.self)
        RealmDataManager.shared.deleteUserLocal(User: toDelete)
        let loginController = LoginRegisterController()
        present(loginController, animated: true, completion: nil)
        
    }
    
    @objc fileprivate func handleNewMessage() {
        let newMessagesController = NewMessageController()
        newMessagesController.messageController = self
        let navController = UINavigationController(rootViewController: newMessagesController)
        present(navController, animated: true, completion: nil)
        
    }

}

extension MessagesController {
    
    fileprivate func registerCells() {
        tableView.register(UserCell.self, forCellReuseIdentifier: "cellId")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.messageContent = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
