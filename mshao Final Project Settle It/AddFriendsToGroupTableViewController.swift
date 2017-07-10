//
//  AddFriendsToGroupTableViewController.swift
//  mshao Final Project Settle It
//
//  Created by Mingfei Shao on 2/12/17.
//  Copyright © 2017 Mingfei Shao. All rights reserved.
//

import UIKit

class AddFriendsToGroupTableViewController: UITableViewController {
    var selectedPaticipant = [Friend]()

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "addFtoG", for: indexPath) as! FriendTableViewCell
        
        // Configure the cell...
        cell.friendNameLabel!.text = friend.firstName! + " " + friend.lastName!
        cell.friendEmailLabel!.text = friend.email
        cell.friendImageView!.image = friend.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                cell.accessoryType = .checkmark
            }
        }
        
        if let indexPaths = tableView.indexPathsForSelectedRows {
            selectedPaticipant.removeAll()
            for path in indexPaths {
                selectedPaticipant.append(friendData[path.row])
            }
            selectedPaticipant.insert(currentUser, at: 0)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
        
        if let indexPaths = tableView.indexPathsForSelectedRows {
            selectedPaticipant.removeAll()
            for path in indexPaths {
                selectedPaticipant.append(friendData[path.row])
            }
            selectedPaticipant.insert(currentUser, at: 0)
        }
    }

}
