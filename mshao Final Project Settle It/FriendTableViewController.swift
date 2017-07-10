//
//  FriendTableViewController.swift
//  mshao Final Project Settle It
//
//  Created by Mingfei Shao on 2/10/17.
//  Copyright © 2017 Mingfei Shao. All rights reserved.
//

import UIKit

class FriendTableViewController: UITableViewController {
    var friendToDeletePath: IndexPath? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88
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
        return friendData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friendData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "friend", for: indexPath) as! FriendTableViewCell
        
        // Configure the cell...
        cell.friendNameLabel!.text = friend.firstName! + " " + friend.lastName!
        cell.friendEmailLabel!.text = friend.email
        cell.friendImageView!.image = friend.image

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let friendToDelete = friendData[indexPath.row]
            friendToDeletePath = indexPath
            displayConfirmDeleteAlert(friendToDelete)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editFriendSegue" {
            let targetViewController = segue.destination as! FriendDetailTableViewController
            let selectedTableCell = sender as! FriendTableViewCell
            let indexPath = tableView.indexPath(for: selectedTableCell)
            let friend = friendData[indexPath!.row]
            targetViewController.friend = friend
        }
    }

    @IBAction func unwindToFriendTableView(_ sender: UIStoryboardSegue) {
        if let fromViewController = sender.source as? FriendDetailTableViewController {
            if let friend = fromViewController.friend {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    friendData[selectedIndexPath.row] = friend
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                }
                else {
                    let newIndexPath = IndexPath(row: friendData.count, section: 0)
                    friendData.append(friend)
                    tableView.insertRows(at: [newIndexPath], with: .bottom)
                }
            }
        }
    }
    
    func displayConfirmDeleteAlert(_ friendToDelete: Friend) {
        let deleteAlert = UIAlertController(title: "Delete Friend", message: "Are you sure you want to permanently delete " + friendToDelete.firstName! + " " + friendToDelete.lastName! + "?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: confirmDelete)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDelete)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func confirmDelete(alertAction: UIAlertAction!) {
        if let indexPath = friendToDeletePath {
            friendData.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    func cancelDelete(alertAction: UIAlertAction!) {
        friendToDeletePath = nil
        tableView.isEditing = false
    }

}
