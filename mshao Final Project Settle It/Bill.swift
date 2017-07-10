//
//  Bill.swift
//  mshao Final Project Settle It
//
//  Created by Mingfei Shao on 2/11/17.
//  Copyright © 2017 Mingfei Shao. All rights reserved.
//

import Foundation
import UIKit

var billData = [
    Bill(title: "BP Gas",
         date: "Mar. 04, 2013",
         owner: currentUser.fullName,
         amount: 12,
         image: UIImage(named: "Gas")!),
    
    Bill(title: "Walmart",
         date: "Mar. 05, 2013",
         owner: friendData[0].fullName,
         amount: 6,
         image: UIImage(named: "Grocery")!),
    
    Bill(title: "PizzaHut",
         date: "Mar. 05, 2013",
         owner: friendData[1].fullName,
         amount: 3,
         image: UIImage(named: "Dining")!),
]

let billTypes = [
    "Gas", "Transport", "Entertain", "Hotel", "Dining", "Grocery", "Electricity",  "Heat", "Water", "General", "Other"
]


class Bill {
    
    var title: String
    var date: String
    var owner: String
    var amount: Float
    var image: UIImage
    
    init(title: String, date: String, owner: String, amount: Float, image: UIImage) {
        self.title = title
        self.date = date
        self.owner = owner
        self.amount = amount
        self.image = image
    }
}
