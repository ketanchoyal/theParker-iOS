//
//  TransactionVC.swift
//  theParker
//
//  Created by Ketan Choyal on 06/02/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

class TransactionVC: UIViewController {
    
    @IBOutlet weak var earningBtnLbl: UILabel!
    @IBOutlet weak var earningBtnView: UIView!
    
    @IBOutlet weak var balanceBtnView: UIView!
    @IBOutlet weak var balanceBtnLbl: UILabel!
    
    @IBOutlet weak var balance_EarningLabel: UILabel!
    @IBOutlet weak var balance_EarningAmountLbl: UILabel!
    
    @IBOutlet weak var transactionTable: UITableView!
    
    var floatingCloseBtn : ActionButton!
    let walletFunc = WalletService.instance
    
    //override func viewDidLayoutSubviews() {
      //  let path = UIBezierPath(roundedRect: <#T##CGRect#>, byRoundingCorners: [<#T##UIRectCorner#>], cornerRadii: <#T##CGSize#>)
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionTable.delegate = self
        transactionTable.dataSource = self
        
        setUpFloatingCloseButton()

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
        UIView.animate(withDuration: 0.3) {
            self.earningBtnLbl.textColor = #colorLiteral(red: 0.2941176471, green: 0, blue: 0.5098039216, alpha: 1)
            self.earningBtnView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.balanceBtnLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.balanceBtnView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0, blue: 0.5098039216, alpha: 1)
            
            self.balance_EarningLabel.text = "Total Earning"
            self.balance_EarningAmountLbl.text = WalletService.instance.earning
        }
    }
    
    @IBAction func balanceBtnTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.earningBtnLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.earningBtnView.backgroundColor = #colorLiteral(red: 0.2941176471, green: 0, blue: 0.5098039216, alpha: 1)
            
            self.balanceBtnLbl.textColor = #colorLiteral(red: 0.2941176471, green: 0, blue: 0.5098039216, alpha: 1)
            self.balanceBtnView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.balance_EarningLabel.text = "Available Balance"
            self.balance_EarningAmountLbl.text = WalletService.instance.balance
        }
    }
}

extension TransactionVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletFunc.balanceTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell") as? TransactionCell else {
            return UITableViewCell()
        }
        
        let transactions = walletFunc.balanceTransactions
        print("ABC : \(transactions.count)")
        print("ABC : \(transactions.keys)")
        let key = Array(transactions.keys)[indexPath.row]
        let transaction = transactions[key]
        
        cell.configureCell(transaction: transaction!)
        
        return cell
    }
    
    
}
