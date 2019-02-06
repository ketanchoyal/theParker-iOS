//
//  TransactionCell.swift
//  theParker
//
//  Created by Ketan Choyal on 06/02/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var transactionIdLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var transactionAmountLbl: UILabel!
    @IBOutlet weak var fromUserNameLbl: UILabel!
    @IBOutlet weak var parkingNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(transaction : Transaction) {
        self.transactionIdLbl.text = "#\(transaction.transId!)"
        self.timeStampLbl.text = transaction.timestamp
        self.parkingNameLbl.text = transaction.for_parking_id
        self.fromUserNameLbl.text = transaction.from
        
        var amount = transaction.amount
        if amount.contains("-") {
            amount = amount.replacingOccurrences(of: "-", with: "", options: [.literal], range: nil)
            self.transactionAmountLbl.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            self.transactionAmountLbl.text = "₹\(amount)"
        } else {
            self.transactionAmountLbl.textColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            self.transactionAmountLbl.text = "₹\(amount)"
        }
        
        
    }
    
}
