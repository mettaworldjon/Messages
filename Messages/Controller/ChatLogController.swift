//
//  ChatLogController.swift
//  Messages
//
//  Created by Jonathan on 11/13/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController:UICollectionViewController, UITextFieldDelegate  {
    
    var user:User? {
        didSet{
            navigationItem.title = user?.name
        }
    }
    
    
    lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter message..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        setupInputComponents()
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
            containerView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor)
            ])
        
        containerView.addSubview(inputTextField)
        NSLayoutConstraint.activate([
            inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
            inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor)
            ])
        
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        NSLayoutConstraint.activate([
            seperatorLineView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor),
            seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            seperatorLineView.heightAnchor.constraint(equalToConstant: 1)
            ])
    }
    
    @objc func handleSend() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        guard let message = inputTextField.text else { return }
        let values = ["text":message,
                      "toId":toId,
                      "fromId":fromId,
                      "timestamp":timestamp
                    ] as [String : Any]
        //        childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            guard let messageId = childRef.key else { return }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(messageId)
            userMessagesRef.setValue(1)
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(messageId)
            recipientUserMessagesRef.setValue(1)
            
        }
    }
}
