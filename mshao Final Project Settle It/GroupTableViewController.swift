//
//  GroupTableViewController.swift
//  mshao Final Project Settle It
//
//  Created by Mingfei Shao on 2/10/17.
//  Copyright © 2017 Mingfei Shao. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {
    var groupToDeletePath: IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 132
        
        groupData[0].paticipants = [currentUser, friendData[0], friendData[1]]
        groupData[0].bills = billData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groupData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groupData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "group", for: indexPath) as! GroupTableViewCell
        
        // Configure the cell...
        cell.groupNameLabel!.text = group.name
        cell.groupDateLabel!.text = group.date
        cell.groupPaticipantLabel!.text = group.paticipants.count.description + " People"
        cell.groupImageView!.image = group.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groupToDelete = groupData[indexPath.row]
            groupToDeletePath = indexPath
            displayConfirmDeleteAlert(groupToDelete)
        }
    }
    
    @IBAction func unwindToGroupTableView(_ sender: UIStoryboardSegue) {
        if let fromViewController = sender.source as? AddNewGroupTableViewController {
            if let group = fromViewController.group {
                let newIndexPath = IndexPath(row: groupData.count, section: 0)
                groupData.append(group)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
        }
        
        if let fromViewController = sender.source as? BillTableViewController {
            if let group = fromViewController.group {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    groupData[selectedIndexPath.row] = group
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
            }
        }
    }
    
    func displayConfirmDeleteAlert(_ groupToDelete: Group) {
        let deleteAlert = UIAlertController(title: "Delete Friend", message: "Are you sure you want to permanently delete Group: " + groupToDelete.name! + "?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: confirmDelete)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDelete)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func confirmDelete(alertAction: UIAlertAction!) {
        if let indexPath = groupToDeletePath {
            groupData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    func cancelDelete(alertAction: UIAlertAction!) {
        groupToDeletePath = nil
        tableView.isEditing = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBillViewSegue" {
            let targetViewController = segue.destination as! BillTableViewController
            let selectedTableCell = sender as! GroupTableViewCell
            let indexPath = tableView.indexPath(for: selectedTableCell)
            let group = groupData[indexPath!.row]
            targetViewController.group = group
        }
    }
}
