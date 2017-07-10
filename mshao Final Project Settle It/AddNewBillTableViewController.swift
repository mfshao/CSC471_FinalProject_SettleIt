//
//  AddNewBillTableViewController.swift
//  mshao Final Project Settle It
//
//  Created by Mingfei Shao on 2/13/17.
//  Copyright © 2017 Mingfei Shao. All rights reserved.
//

import UIKit

class AddNewBillTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var billTypeImageView: UIImageView!
    @IBOutlet weak var billTypePicker: UIPickerView!
    @IBOutlet weak var billTitleTextField: UITextField!
    @IBOutlet weak var billDateTextField: UITextField!
    @IBOutlet weak var billOwnerTextField: UITextField!
    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var billDescriptionTextView: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet var textFields: [UITextField]!
    
    var bills = [Bill]()
    let billPickerData = billTypes
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
        billDescriptionTextView.resignFirstResponder()
        for tf in textFields {
            tf.resignFirstResponder()
        }
        tableView.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == billTypePicker {
            return billPickerData.count
        } else {
            return paticipants.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == billTypePicker {
            return billPickerData[row]
        } else {
            return paticipants[row].fullName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == billTypePicker {
            billTypeImageView.image = UIImage(named: billPickerData[row])
        } else {
            billOwnerTextField.text = paticipants[row].fullName
        }
    }
    
    func setupDatePickerNavPopup() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.lightGray
        
        let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onTodayButtonPressed))
        let doneDateButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(onDonePickerButtonPressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select Date"
        label.textAlignment = NSTextAlignment.center
        let labelButton = UIBarButtonItem(customView: label)
        
        toolBar.setItems([todayButton, flexSpace, labelButton, flexSpace, doneDateButton], animated: true)
        billDateTextField.inputAccessoryView = toolBar
    }
    
    func setupOwnerPickerNavPopup() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.lightGray
        
        let doneDateButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(onDonePickerButtonPressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Select People"
        label.textAlignment = NSTextAlignment.center
        let labelButton = UIBarButtonItem(customView: label)
        
        toolBar.setItems([flexSpace, labelButton, flexSpace, doneDateButton], animated: true)
        billOwnerTextField.inputAccessoryView = toolBar
    }
    
    func onTodayButtonPressed(_ sender: UIBarButtonItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        billDateTextField.text = dateFormatter.string(from: Date())
        billDateTextField.resignFirstResponder()
    }
    
    func onDonePickerButtonPressed(_ sender: UIBarButtonItem) {
        billDateTextField.resignFirstResponder()
        billOwnerTextField.resignFirstResponder()
    }

    func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        billDateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sender = sender as? UIBarButtonItem! {
            if sender === doneButton {
                let title = billTitleTextField.text
                let date = billDateTextField.text
                let owner = billOwnerTextField.text
                let amount = Float(billAmountTextField.text!)!
                let image = billTypeImageView.image
                
                let newBill = Bill(title: title!, date: date!, owner: owner!, amount: amount, image: image!)
                bills.append(newBill)
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "unwindToBillTableViewDone" {
                if validateInput() != true {
                    let title = "Invalid Input"
                    let message = "Bill Title, Date, Paid By and Amount are mandatory!"
                    displayOkayAlert(title: title, message: message)
                    return false
                }
            }
        }
        return true
    }
    
    func validateInput() -> Bool {
        if (billTitleTextField.text?.isEmpty ?? true) || (billDateTextField.text?.isEmpty ?? true)  || (billOwnerTextField.text?.isEmpty ?? true) || (billAmountTextField.text?.isEmpty ?? true) {
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

        billDescriptionTextView.delegate = self
        for tf in textFields {
            tf.delegate = self
        }
        billTypePicker.dataSource = self
        billTypePicker.delegate = self
        
        let ownerPickerView = UIPickerView()
        ownerPickerView.delegate = self
        billOwnerTextField.inputView = ownerPickerView
        ownerPickerView.selectedRow(inComponent: 0)
        
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        billDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddNewBillTableViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
        
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        billDescriptionTextView.layer.borderColor = color
        billDescriptionTextView.layer.borderWidth = 0.5
        billDescriptionTextView.layer.cornerRadius = 5
        
        billTypePicker.selectRow(0, inComponent: 0, animated: true)
        billTypeImageView.image = UIImage(named: billPickerData[0])
        
        setupDatePickerNavPopup()
        setupOwnerPickerNavPopup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
