//
//  AddNewGroupTableViewController.swift
//  mshao Final Project Settle It
//
//  Created by Mingfei Shao on 2/12/17.
//  Copyright © 2017 Mingfei Shao. All rights reserved.
//

import UIKit

class AddNewGroupTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var groupDescriptionTextView: UITextView!
    @IBOutlet weak var paticipantsTextField: UITextField!
    @IBOutlet var textFields: [UITextField]!
    
    var group: Group?
    let imagePicker = UIImagePickerController()
    var paticipants = [Friend]()
    
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
    
    func setupDatePickerNavPopup() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.lightGray
        
        let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onTodayButtonPressed))
        let doneDateButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(onDoneDateButtonPressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select Date"
        label.textAlignment = NSTextAlignment.center
        let labelButton = UIBarButtonItem(customView: label)

        toolBar.setItems([todayButton, flexSpace, labelButton, flexSpace, doneDateButton], animated: true)
        dateTextField.inputAccessoryView = toolBar
    }
    
    func onTodayButtonPressed(_ sender: UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateTextField.text = dateFormatter.string(from: Date())
        dateTextField.resignFirstResponder()
    }
    
    func onDoneDateButtonPressed(_ sender: UIBarButtonItem) {
        dateTextField.resignFirstResponder()
    }
    
    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        sender.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        datePickerValueChanged(datePicker)
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateTextField.text = dateFormatter.string(from: sender.date)
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
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        groupImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? UIBarButtonItem! {
            if sender === doneButton {
                let name = groupNameTextField.text
                let date = dateTextField.text
                let description = groupDescriptionTextView.text
                let image = groupImageView.image
                
                group = Group(name: name, date: date, description: description, image: image)
                group?.setPaticipant(paticipants: paticipants)
            }
        }
        
        if segue.identifier == "showAFtoGSegue" {
            let targetViewController = segue.destination as! AddFriendsToGroupTableViewController
            targetViewController.selectedPaticipant = paticipants
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "unwindToGroupTableView" {
                if validateInput() != true {
                    let title = "Invalid Input"
                    let message = "Group Name, Date and Participants are mandatory!"
                    displayOkayAlert(title: title, message: message)
                    return false
                }
            }
        }
        return true
    }
    
    func validateInput() -> Bool {
        if (groupNameTextField.text?.isEmpty ?? true) || (dateTextField.text?.isEmpty ?? true)  || (paticipantsTextField.text?.isEmpty ?? true) {
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print(textField === paticipantsTextField)
        if textField === paticipantsTextField {
            performSegue(withIdentifier: "showAFtoGSegue", sender: self)
            return false
        }
        
        return true
    }
    
    @IBAction func beginEditPaticipant(_ sender: UITextField) {
        performSegue(withIdentifier: "showAFtoGSegue", sender: self)
    }
    
    @IBAction func unwindToAddNewGroupTableView(_ sender: UIStoryboardSegue) {
        if let fromViewController = sender.source as? AddFriendsToGroupTableViewController {
            paticipants = fromViewController.selectedPaticipant
        }
        
        var text = ""
        for p in paticipants {
            text += p.firstName! + " " + p.lastName! + ", "
        }
        
        paticipantsTextField.text = text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupDescriptionTextView.delegate = self
        for tf in textFields {
            tf.delegate = self
        }
        imagePicker.delegate = self
        paticipantsTextField.inputView = UIView();
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddNewGroupTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        groupDescriptionTextView.layer.borderColor = color
        groupDescriptionTextView.layer.borderWidth = 0.5
        groupDescriptionTextView.layer.cornerRadius = 5
        
        setupDatePickerNavPopup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
