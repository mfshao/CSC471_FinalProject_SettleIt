//
//  Friend.swift
//  mshao Final Project Settle It
//
//  Created by Mingfei Shao on 2/10/17.
//  Copyright © 2017 Mingfei Shao. All rights reserved.
//

import Foundation
import UIKit

var currentUser = Friend(firstName: "Mingfei",
                         lastName: "Shao",
                         cellphone: "1234567",
                         email: "email@email.com",
                         description: "The current user",
                         image: UIImage(named: "MingfeiShao"))

var friendData = [
    
    Friend(firstName: "John",
           lastName: "Smith",
           cellphone: "888888",
           email: "jsmith@email.com",
           description: "",
           image: UIImage(named: "JohnSmith")),
    
    Friend(firstName: "Jane",
           lastName: "Doe",
           cellphone: "162622",
           email: "janedoe@website.com",
           description: ""),
    
    Friend(firstName: "San",
           lastName: "Zhang",
           cellphone: "333333",
           email: "san@website.com",
           description: ""),
    
    Friend(firstName: "Si",
           lastName: "Li",
           cellphone: "44444",
           email: "lisi@email.com",
           description: "",
           image: UIImage(named: "SiLi")),
    
]

class Friend {
    var firstName: String?
    var lastName: String?
    var cellphone: String?
    var email: String?
    var description: String?
    var image: UIImage? = UIImage(named: "Default")
    var fullName: String
    
    init(firstName: String? = nil,
         lastName: String? = nil,
         cellphone: String? = nil,
         email: String? = nil,
         description: String? = nil,
         image: UIImage? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.cellphone = cellphone
        self.email = email
        self.description = description
        if let image = image {
            self.image = image
        }
        self.fullName = firstName! + " " + lastName!
    }
}
