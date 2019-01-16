//
//  WalletService.swift
//  theParker
//
//  Created by Ketan Choyal on 13/01/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import Foundation
import Firebase

class WalletService {
    static let instance = WalletService()
    
    var balance : String!
    var earning : String!
    
    func load_Balance_Earning() {
                
        REF_USER_EARNING.observe(.value) { (earningSnapshot) in
            guard let earningData = earningSnapshot.value as? [String : AnyObject] else { return }
            
            let earning = earningData["earning"] as? String
            self.earning = earning
            print("Userid : Earning : \(earning!)")
        }
        
        REF_USER_BALANCE.observe(.value) { (balanceSnapshot) in
            guard let balanceData = balanceSnapshot.value as? [String : AnyObject] else { return }
            
            let balance = balanceData["balance"] as? String
            self.balance = balance
            print("Userid : Balance : \(balance!)")
        }
    }
    
}
