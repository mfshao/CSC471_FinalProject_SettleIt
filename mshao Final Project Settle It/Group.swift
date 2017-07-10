//
//  Group.swift
//  mshao Final Project Settle It
//
//  Created by Mingfei Shao on 2/10/17.
//  Copyright © 2017 Mingfei Shao. All rights reserved.
//

import Foundation
import UIKit

var groupData = [
    
    Group(name: "Test GROUP",
          date: "Jan. 21, 2013",
          description: "dd"),
    
]

class Group {
    var name: String?
    var date: String?
    var description: String?
    var paticipants: [Friend]
    var bills: [Bill]
    var image: UIImage? = UIImage(named: "DefaultGroup")
    
    init(name: String? = nil, date: String? = nil, description: String? = nil, image: UIImage? = nil) {
        self.name = name
        self.date = date
        self.description = description
        self.paticipants = []
        self.paticipants.append(currentUser)
        self.bills = []
        if let image = image {
            self.image = image
        }
    }
    
    func setPaticipant(paticipants: [Friend]) {
        self.paticipants = paticipants
    }
    
    func getPaticipantCount() -> Int{
        return paticipants.count
    }
}
