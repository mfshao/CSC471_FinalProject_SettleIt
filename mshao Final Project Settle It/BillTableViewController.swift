//
//  BillTableViewController.swift
//  mshao Final Project Settle It
//
//  Created by Mingfei Shao on 2/10/17.
//  Copyright © 2017 Mingfei Shao. All rights reserved.
//

import UIKit

class BillTableViewController: UITableViewController {
    @IBOutlet weak var ownedLabel: UILabel!
    @IBOutlet weak var oweLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var billToDeletePath: IndexPath? = nil
    var group: Group?
    var totalOwe: Float = 0.0
    var totalOwned: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
        
        if group != nil {
            tableView.reloadData()
            updateHeaderValues()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources tvar can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return group!.bills.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let cell = tableView.dequeueReusableCell(withIdentifier: "bill", for: indexPath) as! BillTableViewCell
        
        // Configure the cell...
        if let group = group {
            let bill = group.bills[indexPath.row]
      
            cell.billTitle.text = bill.title
            cell.billOwner.text = bill.owner + " Paid"
            cell.billAmount.text = "$ " + String(format: "%.2f", bill.amount)
            cell.billDate.text = bill.date
            cell.billImageView.image = bill.image
            let value = bill.amount / Float(group.paticipants.count)
            
            if bill.owner != currentUser.fullName {
                cell.billShareAmount.textColor = UIColor.red
                cell.billShareAmount.text = "You Borrowed\n $ " + String(format: "%.2f", value)
            } else {
                cell.billShareAmount.textColor = UIColor(red: 0.0/255, green: 128.0/255, blue: 0.0/255, alpha: 1.0)
                cell.billShareAmount.text = "You Lent\n $ " + String(format: "%.2f", bill.amount - value)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let billToDelete = group?.bills[indexPath.row]
            billToDeletePath = indexPath
            displayConfirmDeleteAlert(billToDelete!)
        }
    }
    
    func displayConfirmDeleteAlert(_ billToDelete: Bill) {
        let deleteAlert = UIAlertController(title: "Delete Bill", message: "Are you sure you want to permanently delete " + billToDelete.title + "?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: confirmDelete)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDelete)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func confirmDelete(alertAction: UIAlertAction!) {
        if let indexPath = billToDeletePath {
            group?.bills.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            updateHeaderValues()
        }
    }
    
    func cancelDelete(alertAction: UIAlertAction!) {
        billToDeletePath = nil
        tableView.isEditing = false
    }
    
    func updateHeaderValues() {
        if let group = group {
            totalOwe = 0.0
            totalOwned = 0.0
            var totalPerPerson: Float = 0.0
            
            let bills = group.bills
            for b in bills {
                if b.owner != currentUser.fullName {
                    totalOwe += b.amount / Float(group.paticipants.count)
                } else {
                    totalOwned += (b.amount - (b.amount / Float(group.paticipants.count)))
                }
                totalPerPerson += b.amount / Float(group.paticipants.count)
            }

            ownedLabel.text = "$ " + String(format: "%.2f", totalOwned)
            oweLabel.text = "$ " + String(format: "%.2f", totalOwe)
            totalLabel.text = "$ " + String(format: "%.2f", totalPerPerson)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddBillSegue" {
            let targetViewController = segue.destination as! AddNewBillTableViewController
            if let group = group {
                targetViewController.paticipants = group.paticipants
                targetViewController.bills = group.bills
            }
        }
    }
    
    @IBAction func unwindToBillTableView(_ sender: UIStoryboardSegue) {
        if let fromViewController = sender.source as? AddNewBillTableViewController {
            if let group = group {
                group.bills = fromViewController.bills
                tableView.reloadData()
                updateHeaderValues()
            }
        }
    }

    @IBAction func onSettleButtonPressed(_ sender: UIButton) {
        let received = BillSettler.calculate(group: group!)
        let title = "Settlement Result"
        var message = ""
        
        if received.count > 0 {
            for r in received {
                message += r.sender + " pays " + r.receiver + " $ " + String(format: "%.2f", r.amount) + "\n"
            }
            message += "\nYou are all set!"
        } else {
            message = "Bills are already settled!"
        }
        
        let resultAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let gotItAction = UIAlertAction(title: "Got it!", style: .default, handler: nil)
        resultAlert.addAction(gotItAction)
        present(resultAlert, animated: true, completion: nil)
    }
}
