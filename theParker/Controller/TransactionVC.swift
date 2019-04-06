//
//  TransactionVC.swift
//  theParker
//
//  Created by Ketan Choyal on 06/02/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

enum TransactionType {
    case Earning
    case Balance
}

class TransactionVC: UIViewController {
    
    @IBOutlet weak var earningView: UIView!
    @IBOutlet weak var balanceView: UIView!
    
    @IBOutlet weak var earningBtnLbl: UILabel!
    @IBOutlet weak var earningBtnView: UIView!
    
    @IBOutlet weak var balanceBtnView: UIView!
    @IBOutlet weak var balanceBtnLbl: UILabel!
    
    @IBOutlet weak var balance_EarningLabel: UILabel!
    @IBOutlet weak var balance_EarningAmountLbl: UILabel!
    
    @IBOutlet weak var earningTransactionTable: UITableView!
    @IBOutlet weak var balanceTransactionTable: UITableView!
    
    var floatingCloseBtn : ActionButton!
    let walletFunc = WalletService.instance
    
    var transactionType = TransactionType.Balance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        balanceTransactionTable.delegate = self
        balanceTransactionTable.dataSource = self
        
        earningTransactionTable.delegate = self
        earningTransactionTable.dataSource = self
        
        setUpFloatingCloseButton()
        
        balanceViewTapped()
        
//        print("Earnings")
//        walletFunc.getEarningTransactions { (success) in
//            if success {
//                self.transactionTable.reloadData()
//            }
//        }
//        print("Balance")
//        walletFunc.getBalanceTransactions { (success) in
//            if success {
//                self.transactionTable.reloadData()
//            }
//        }
    }
    
    func setUpFloatingCloseButton() {
        floatingCloseBtn = ActionButton(attachedToView: self.view, items: nil, buttonHeight: 45, buttonWidth: 45, buttonType: .Rectangle, position: .BottomRight)
        floatingCloseBtn.bottomSpacing(space: 85)
        floatingCloseBtn.show()
        floatingCloseBtn.setImage(UIImage(named: "close"), forState: UIControl.State())
        floatingCloseBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        floatingCloseBtn.cornerRadius(radius: 10)
        floatingCloseBtn.action = {editButtonItem in self.closeVC()}
    }
    
    func closeVC() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension TransactionVC {
    
    @IBAction func earningBtnTapped(_ sender: Any) {
        
        earningViewTapped()
    }
    
    @IBAction func balanceBtnTapped(_ sender: Any) {
        balanceViewTapped()
    }
}

extension TransactionVC {
    func balanceViewTapped() {
        
        transactionType = .Balance
        
        UIView.animate(withDuration: 0.3) {
            
            self.balanceView.isHidden = false
            self.earningView.isHidden = true
            
            self.earningBtnLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.earningBtnView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0, blue: 0.5098039216, alpha: 1)
            
            self.balanceBtnLbl.textColor = #colorLiteral(red: 0.2941176471, green: 0, blue: 0.5098039216, alpha: 1)
            self.balanceBtnView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.balance_EarningLabel.text = "Available Balance"
            self.balance_EarningAmountLbl.text = WalletService.instance.balance
        }
        balanceTransactionTable.reloadData()
    }
    
    func earningViewTapped() {
        transactionType = .Earning
        
        UIView.animate(withDuration: 0.3) {
            self.balanceView.isHidden = true
            self.earningView.isHidden = false
            self.earningBtnLbl.textColor = #colorLiteral(red: 0.2941176471, green: 0, blue: 0.5098039216, alpha: 1)
            self.earningBtnView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.balanceBtnLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.balanceBtnView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0, blue: 0.5098039216, alpha: 1)
            
            self.balance_EarningLabel.text = "Total Earning"
            self.balance_EarningAmountLbl.text = WalletService.instance.earning
        }
        earningTransactionTable.reloadData()
    }
}

extension TransactionVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var ret = 0
        
        switch transactionType {
        case .Balance:
            ret = walletFunc.balanceTransactions.count
            break
        case .Earning:
            ret = walletFunc.earningTransactions.count
            break
        }
        
        return ret
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as? TransactionCell else {
            return UITableViewCell()
        }
            
        switch transactionType {
        case .Balance:
            
            let transactions = walletFunc.balanceTransactions
//            print("ABC : \(transactions.count)")
//            print("ABC : \(transactions.keys)")
            let key = Array(transactions.keys)[indexPath.row]
            let transaction = transactions[key]
            
            cell.configureCell(transaction: transaction!)
            
            break
        case .Earning:
            
            let transactions = walletFunc.earningTransactions
//            print("ABC : \(transactions.count)")
//            print("ABC : \(transactions.keys)")
            let key = Array(transactions.keys)[indexPath.row]
            let transaction = transactions[key]
            
            cell.configureCell(transaction: transaction!)
            
            break
        }
        
        return cell
        
    }
    
}
