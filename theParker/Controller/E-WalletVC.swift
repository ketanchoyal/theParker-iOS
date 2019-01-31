//
//  E-WalletVC.swift
//  theParker
//
//  Created by Ketan Choyal on 26/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit
import Lottie

class E_WalletVC: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var earnedMoneyLabel: UILabel!
    @IBOutlet weak var balanceMoneyLabel: UILabel!
    
    let walletFunc = WalletService.instance
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        walletFunc.load_Balance_Earning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Do any additional setup after loading the view.
        
        walletFunc.load_Balance_Earning()
        
        earnedMoneyLabel.text = "₹\(walletFunc.earning!)"
        balanceMoneyLabel.text = "₹\(walletFunc.balance!)"
        
        print("Earnings")
        walletFunc.getEarningTransactions { (success) in }
        print("Balance")
        walletFunc.getBalanceTransactions { (success) in }
        
    }
    
    @IBAction func menuBtn(_ sender: Any) {
    }

    @IBAction func earningTransactionBtnTapped(_ sender: Any) {
    }
    
    @IBAction func walletTransactionBtnTapped(_ sender: Any) {
    }
}
