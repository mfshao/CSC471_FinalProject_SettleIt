//
//  FriendDetailTableViewController.swift
//  mshao Final Project Settle It
//
//  Created by Mingfei Shao on 2/11/17.
//  Copyright © 2017 Mingfei Shao. All rights reserved.
//

import UIKit

class FriendDetailTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cellphoneTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet var textFields: [UITextField]!
    
    var friend: Friend?
    let imagePicker = UIImagePickerController()
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    @IBAction func onCameraButtonPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker, animated: true, completion: nil)
        } else {
            let title = "No Camera"
            let message = "No camera has been found on this device!"
            displayOkayAlert(title: title, message: message)
        }
    }
    
    @IBAction func onLibraryButtonPressen (_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onCancelButtonPressed(_ sender: UIBarButtonItem) {
        let isAdding = presentingViewController is UITabBarController
        
        print(isAdding)
        if isAdding {
            dismiss(animated: true, completion: nil)
        }
        else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        friendImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? UIBarButtonItem! {
            if sender === doneButton {
                let firstName = firstNameTextField.text
                let lastName = lastNameTextField.text
                let cellphone = cellphoneTextField.text
                let email = emailTextField.text
                let description = descriptionTextView.text
                let image = friendImageView.image
                
                friend = Friend(firstName: firstName, lastName: lastName, cellphone: cellphone, email: email, description: description, image: image)
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "unwindToFriendTableView" {
                if validateInput() != true {
                    let title = "Invalid Input"
                    let message = "First Name, Last Name, and Email are mandatory!"
                    displayOkayAlert(title: title, message: message)
                    return false
                }
            }
        }
        return true
    }
    
    func validateInput() -> Bool {
        if (firstNameTextField.text?.isEmpty ?? true) || (lastNameTextField.text?.isEmpty ?? true) || (emailTextField.text?.isEmpty ?? true) {
            return false
        }
        
        return true
    }
    
    func displayOkayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        for tf in textFields {
            tf.delegate = self
        }
        imagePicker.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FriendDetailTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        descriptionTextView.layer.borderColor = color
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.cornerRadius = 5
        
        if let friend = friend {
            firstNameTextField.text = friend.firstName
            lastNameTextField.text = friend.lastName
            emailTextField.text = friend.email
            if let fCellphone = friend.cellphone {
                cellphoneTextField.text = fCellphone
            }
            if let fDescription = friend.description {
                descriptionTextView.text = fDescription
            }
            if let fImage = friend.image {
                friendImageView.image = fImage
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
