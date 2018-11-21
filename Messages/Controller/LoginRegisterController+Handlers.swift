//
//  LoginRegisterController+Handlers.swift
//  Messages
//
//  Created by Jonathan on 11/10/18.
//  Copyright © 2018 Jonathan. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

// Image Picker
extension LoginRegisterController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func hanldeImageSelector() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker:UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage? {
            selectedImageFromPicker = editedImage
        } else if let orginalImage = info[.originalImage] as? UIImage? {
            selectedImageFromPicker = orginalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
            profileImageView.clipsToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled Picker")
        dismiss(animated: true, completion: nil)
    }
}

// Register Handler
extension LoginRegisterController {
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            handleRegister()
        } else {
            handleLogin()
        }
    }
    
    
    fileprivate func handleRegister() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let name = nameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (User, error) in
            // Check for Error
            if let safeError = error {
                print(safeError)
                return
            }
            print("Added!!!!!")
            // Successfully Auth User
            guard let uid = User?.user.uid else { return }
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = self.profileImageView.imageView?.image?.jpegData(compressionQuality: 0.1) {
                
                // Upload Image
                storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                    
                    // Error Check
                    if let error = err {
                        print(error)
                        return
                    }
                    
                    // Pull Image URL
                    storageRef.downloadURL(completion: { (URL, err) in
                        
                        // Error Check
                        if let error = err {
                            print(error)
                            return
                        }
                        
                        guard let url = URL else { return }
                        let values = ["name": name, "email": email, "profileImageURL": url.absoluteString]
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    })
                    
                })
                
            }
        }
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values:[String:AnyObject]) {
        let ref = Database.database().reference()
        let usersRef = ref.child("users").child(uid)
        usersRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if let err = error {
                print(err)
                return
            }
            print("Saved user sucessfully into Firebase DB")
            DispatchQueue.main.async {
                let user = UserData()
                guard let email = self.emailTextField.text else { return }
                guard let name = self.nameTextField.text else { return }
                user.email = email
                user.name = name
                RealmDataManager.shared.insertUserLocal(User: user)
                self.dismiss(animated: true, completion: {
                    
                })
            }
        })
    }
    
    
    fileprivate func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        if email != "" && password != ""{
            Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
                // Check for Error
                if let err = error {
                    print(err)
                    return
                }
                
                // Successfully Auth
                print("Succesfully Auth")
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().reference().child("users").child(uid).observe(.value, with: { (DataSnapshot) in
                    if let safeData = DataSnapshot.value as? [String:Any] {
                        let user = UserData()
                        user.name = safeData["name"] as? String
                        user.email = email
                        try! RealmDataManager.shared.realm.write {
                            RealmDataManager.shared.realm.add(user)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            }
        } else {
            print("Blank Text Field")
        }
    }
}
