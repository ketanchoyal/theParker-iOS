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
    
    func parking_purchase_transaction(transaction : Transaction, handler : @escaping (_ complete : Bool) -> ()) {
        let myTransaction = [
            "amount" : String(NSString(string: transaction.amount).doubleValue * -1),
            "for_parking_id" : transaction.for_parking_id,
            "from" : transaction.from,
            "to" : transaction.to
        ]
        
        let userTransaction = [
            "amount" : String(NSString(string: transaction.amount).doubleValue),
            "for_parking_id" : transaction.for_parking_id,
            "from" : transaction.from,
            "to" : transaction.to
        ]
        
        //TODO : Transaction Logic
        
        let transactionKey = REF_USER_BALANCE_TRANSACTION.childByAutoId().key
        
        getEarning(of: transaction.to, amount: transaction.amount) { (success) in
            if success {
                REF_USER_BALANCE_TRANSACTION.child(transactionKey!).updateChildValues(myTransaction, withCompletionBlock: { (error, ref) in
                    if error == nil {
                        REF_USER.child(transaction.to).child("Wallet/Earning").child("transactions").child(transactionKey!).updateChildValues(userTransaction, withCompletionBlock: { (error, ref) in
                            if error == nil {
                                handler(true)
                            } else {
                                handler(false)
                            }
                        })
                    } else {
                        handler(false)
                    }
                })
            } else {
                handler(false)
            }
        }
        
    }
    
    private func getEarning(of userId : String, amount : String, handler : @escaping (_ complete : Bool) -> ()) {
        
        let ref = REF_USER.child(userId).child("Wallet/Earning")
        var oldEarning : Double!
        ref.observeSingleEvent(of: .value) { (earningSnapshot) in
            guard let earningData = earningSnapshot.value as? [String : AnyObject] else {
                handler(false)
                return }
            
            let userEarningStr = earningData["earning"] as? String
            oldEarning = NSString(string: userEarningStr!).doubleValue
            self.addEarning(ref: ref, oldEarning: oldEarning, amount: amount, handler: { (success) in
                if success {
                    handler(true)
                } else {
                    handler(false)
                }
            })
        }
        
    }
    
    private func addEarning(ref : DatabaseReference,oldEarning : Double, amount : String, handler : @escaping (_ complete : Bool) -> ()) {
        let newEarning = oldEarning + NSString(string: amount).doubleValue
        
        let Earning = [
            "earning" : String(newEarning)
            ] as [String : Any]
        
        ref.updateChildValues(Earning, withCompletionBlock: { (error, dref) in
            if error == nil {
                let newBalance = NSString(string: self.balance!).doubleValue - NSString(string: amount).doubleValue
                
                let Balance = [
                    "balance" : String(newBalance)
                    ] as [String : Any]
                
                REF_USER_BALANCE.updateChildValues(Balance, withCompletionBlock: { (error, dref) in
                    if error == nil {
                        handler(true)
                    } else {
                        handler(false)
                    }
                })
            } else {
                handler(false)
            }
        })
    }
    
}
