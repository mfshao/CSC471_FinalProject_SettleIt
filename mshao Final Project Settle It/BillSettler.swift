
//
//  BillSettler.swift
//  mshao Final Project Settle It
//
//  Created by Mingfei Shao on 2/13/17.
//  Copyright © 2017 Mingfei Shao. All rights reserved.
//

import Foundation

class BillSettler {
    class Result {
        var sender: String = ""
        var receiver: String = ""
        var amount: Float = 0.0
        
        init(sender: String, receiver: String, amount: Float) {
            self.sender = sender
            self.receiver = receiver
            self.amount = amount
        }
    }
    
    class func calculate(group: Group) -> [Result] {
        let paticipants = group.paticipants
        let bills = group.bills
        var balanceSheet = [String: Float]()
        var resolved = 0
        var resultArray = [Result]()
        let tolerance: Float = 0.009
        
        for p in paticipants {
            balanceSheet[p.fullName] = 0.0
        }
        
        for b in bills {
            let bValue = b.amount / Float(paticipants.count)
            for (key, value) in balanceSheet {
                if (key != b.owner) {
                    balanceSheet.updateValue(value - bValue, forKey: key)
                } else {
                    balanceSheet.updateValue(value + Float(b.amount - bValue), forKey: key)
                }
            }
        }
        
        while (resolved < balanceSheet.count) {
            print(resolved)
            let sortedBS = Array(balanceSheet).sorted {$0.1 < $1.1}
            let senderName = sortedBS[0].key
            var senderShouldSend = Swift.abs(sortedBS[0].value)
            let receiverName = sortedBS[sortedBS.count-1].key
            var receiverShouldReceive = Swift.abs(sortedBS[sortedBS.count-1].value)
            var amount: Float = 0.0
            
            if senderShouldSend > receiverShouldReceive {
                amount = receiverShouldReceive
            } else {
                amount = senderShouldSend
            }
            
            balanceSheet.updateValue(sortedBS[0].value + amount, forKey: senderName)
            balanceSheet.updateValue(sortedBS[sortedBS.count-1].value - amount, forKey: receiverName)
            
            resultArray.append(Result(sender: senderName, receiver: receiverName, amount: amount))
            
            senderShouldSend = Swift.abs(sortedBS[0].value + amount)
            receiverShouldReceive = Swift.abs(sortedBS[sortedBS.count-1].value - amount)
            if senderShouldSend <= tolerance{
                resolved += 1
            }
            if receiverShouldReceive <= tolerance {
                resolved += 1
            }
        }
        
        return resultArray.filter{ $0.amount > tolerance}
    }
}
