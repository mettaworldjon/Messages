//
//  Usercell.swift
//  Messages
//
//  Created by Jonathan on 11/17/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var messageContent:Message? {
        didSet {
            if let toId = messageContent?.toId {
                let ref = Database.database().reference().child("users").child(toId)
                ref.observeSingleEvent(of: .value) { (DataSnapshot) in
                    if let dictionary = DataSnapshot.value as? [String:AnyObject] {
                        ///// HERE!!!!!!!
                        self.textLabel?.text = dictionary["name"] as? String
                        self.profileImageView.loadImageUsingCahceWithURLString(dictionary["profileImageURL"] as! String)
                        self.detailTextLabel?.text = self.messageContent?.text
                        if let seconds = self.messageContent?.timestamp?.doubleValue {
                            let timestampDate = Date(timeIntervalSince1970: seconds)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "hh:mm:ss a"
                            self.timeLabel.text = dateFormatter.string(from: timestampDate)
                        }
                    }
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let name = textLabel, let email = detailTextLabel else { return  }
        name.frame = CGRect(x: 64, y: name.frame.origin.y + 2, width: name.frame.width, height: name.frame.height)
        email.frame = CGRect(x: 64, y: email.frame.origin.y + 2, width: email.frame.width, height: email.frame.height)
    }
    
    let profileImageView:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 24
        return image
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 48),
            profileImageView.widthAnchor.constraint(equalToConstant: 48),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            ])
        
        self.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor, constant: 0),
            timeLabel.widthAnchor.constraint(equalToConstant: 100)
            ])
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
