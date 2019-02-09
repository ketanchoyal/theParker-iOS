//
//  TransactionCell.swift
//  theParker
//
//  Created by Ketan Choyal on 06/02/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var transactionIdLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var transactionAmountLbl: UILabel!
    @IBOutlet weak var fromUserNameLbl: UILabel!
    @IBOutlet weak var parkingNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainView.round(corners: [.allCorners], radius: 5.0, borderColor: #colorLiteral(red: 0.2980392157, green: 0.09019607843, blue: 0.4901960784, alpha: 1), borderWidth: 4.0)
        self.timeView.round(corners: [.topLeft, .bottomLeft], radius: 12.0)
        
    }

    func configureCell(transaction : Transaction) {
        
        self.transactionIdLbl.text = "#\(transaction.transId![NSRange(location: 1, length: 10)])"
        self.parkingNameLbl.text = transaction.for_parking_id
        self.fromUserNameLbl.text = transaction.from
        
        let timeStamp = transaction.timestamp
        
        timeStamp?.date_Year_Time(DYT: { (date, year, time) in
            self.timeLbl.text = time
            self.yearLbl.text = year.uppercased()
            self.dateLbl.text = date.uppercased()
        })
        
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
