//
//  NewMessageController.swift
//  Messages
//
//  Created by Jonathan on 11/9/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var serverUsers = [User]()
    var messageController:MessagesController?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        fetchUsers()
        registerCell()
    }
    
    fileprivate func registerCell() {
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded) { (DataSnapshot) in
            if let dataDictionary = DataSnapshot.value as? [String:AnyObject] {
                let user = User(dictionary: dataDictionary)
                user.id = DataSnapshot.key
                self.serverUsers.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    fileprivate func setupNav() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.title = "New Message"
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}


extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)  as! UserCell
        if serverUsers.count > 0 {
            let user = serverUsers[indexPath.row]
            cell.textLabel?.text = user.name
            cell.detailTextLabel?.text = user.email
            if let profileURL = serverUsers[indexPath.row].profileImageURL {
                cell.profileImageView.loadImageUsingCahceWithURLString(profileURL)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            let user = self.serverUsers[indexPath.row]
            self.messageController?.showChatController(user: user)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverUsers.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
