//
//  LoginRegisterController.swift
//  Messages
//
//  Created by Jonathan on 11/8/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class LoginRegisterController: UIViewController {
    
    let profileImageView:UIButton = {
        let imageView = UIButton()
        imageView.setImage(UIImage(named: "gameofthrones_splash"), for: .normal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.imageView?.contentMode = .scaleAspectFill
        imageView.addTarget(self, action: #selector(hanldeImageSelector), for: .touchUpInside)
        return imageView
    }()
    
    
    
    let loginRegisterSegmentedControl:UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 1
        sc.tintColor = .white
        sc.addTarget(self, action: #selector(handleLoginRegisterSwitch), for: .valueChanged)
        
        return sc
    }()

    @objc fileprivate func handleLoginRegisterSwitch() {
        // Login
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            loginFormat()
        }
        // Register
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            registerFormat()
        }
    }
    
    fileprivate func loginFormat() {
        UIView.animate(withDuration: 0.1, animations: {
            self.nameTextField.alpha = 0
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.inputStackView.removeArrangedSubview(self.nameTextField)
                self.emailTextField.layer.cornerRadius = 5
                self.emailTextField.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                self.view.layoutIfNeeded()
            })
        }
    }
    
    fileprivate func registerFormat() {
        UIView.animate(withDuration: 0.2, animations: {
            self.inputStackView.insertArrangedSubview(self.nameTextField, at: 0)
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                self.emailTextField.layer.cornerRadius = 0
                self.nameTextField.alpha = 1
            })
        }
    }
    
    let inputStackView:UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .red
        sv.axis = .vertical
        return sv
    }()
    
    let nameTextField:UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Name"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5
        tf.clipsToBounds = true
        tf.alpha = 1
        tf.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tf.setLeftPaddingPoints(12)
        NSLayoutConstraint.activate([tf.heightAnchor.constraint(equalToConstant: 50)])
        return tf
    }()
    
    let emailTextField:UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.backgroundColor = .white
        tf.setLeftPaddingPoints(12)
        NSLayoutConstraint.activate([tf.heightAnchor.constraint(equalToConstant: 50)])
        return tf
    }()
    
    let passwordTextField:UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 5
        tf.clipsToBounds = true
        tf.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        tf.setLeftPaddingPoints(12)
        NSLayoutConstraint.activate([tf.heightAnchor.constraint(equalToConstant: 50)])
        return tf
    }()
    
    let loginRegisterButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        btn.setTitle("Register", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return btn
    }()
    
    
    fileprivate func seperatorView() -> UIView {
        let nameSeperator:UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            return view
        }()
        return nameSeperator
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        setupInputStackContainer()
        setupLoginRegisterButton()
        setupLoginRegisterSegment()
        setupProfileImage()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupProfileImage() {
        view.addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12)
            ])
    }
    
    
    fileprivate func setupLoginRegisterSegment() {
        view.addSubview(loginRegisterSegmentedControl)
        NSLayoutConstraint.activate([
            loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputStackView.widthAnchor),
            loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36),
            loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputStackView.topAnchor, constant: -12)
            ])
    }
    
    fileprivate func setupInputStackContainer() {
        view.addSubview(inputStackView)
        NSLayoutConstraint.activate([
            inputStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            inputStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -35),
            inputStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24)
            ])
        
        inputStackView.addArrangedSubview(nameTextField)
        let nameLine:UIView = seperatorView()
        nameTextField.addSubview(nameLine)
        NSLayoutConstraint.activate([
            nameLine.widthAnchor.constraint(equalTo: nameTextField.widthAnchor, constant: 0),
            nameLine.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 0),
            nameLine.bottomAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 0)
            ])
        
        inputStackView.addArrangedSubview(emailTextField)
        let emailLine:UIView = seperatorView()
        emailTextField.addSubview(emailLine)
        NSLayoutConstraint.activate([
            emailLine.widthAnchor.constraint(equalTo: emailTextField.widthAnchor, constant: 0),
            emailLine.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor, constant: 0),
            emailLine.bottomAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0)
            ])
        inputStackView.addArrangedSubview(passwordTextField)
    }
    
    fileprivate func setupLoginRegisterButton() {
        view.addSubview(loginRegisterButton)
        NSLayoutConstraint.activate([
            loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginRegisterButton.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 12),
            loginRegisterButton.widthAnchor.constraint(equalTo: inputStackView.widthAnchor),
            loginRegisterButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
