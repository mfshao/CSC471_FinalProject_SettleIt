//
//  BillTableViewCell.swift
//  mshao Final Project Settle It
//
//  Created by Mingfei Shao on 2/10/17.
//  Copyright © 2017 Mingfei Shao. All rights reserved.
//

import UIKit

class BillTableViewCell: UITableViewCell {
    @IBOutlet weak var billImageView: UIImageView!
    @IBOutlet weak var billTitle: UILabel!
    @IBOutlet weak var billDate: UILabel!
    @IBOutlet weak var billOwner: UILabel!
    @IBOutlet weak var billShareAmount: UITextView!
    @IBOutlet weak var billAmount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
