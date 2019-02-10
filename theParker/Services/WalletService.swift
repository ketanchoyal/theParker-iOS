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
    
    var earningTransactions = [String : Transaction]()
    var balanceTransactions = [String : Transaction]()
    
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
            "to" : transaction.to,
            "timestamp": [".sv": "timestamp"]
            ] as [String : Any]
        
        let userTransaction = [
            "amount" : String(NSString(string: transaction.amount).doubleValue),
            "for_parking_id" : transaction.for_parking_id,
            "from" : transaction.from,
            "to" : transaction.to,
            "timestamp": [".sv": "timestamp"]
            ] as [String : Any]
        
        //MARK : Transaction Logic
        
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
    
    func getEarningTransactions(completionHandler : @escaping (_ complete : Bool) -> ()) {
        
        REF_USER_EARNING_TRANSACTION.observe(.value) { (earningTranSnapshot) in
            guard let earningTranSnapshot = earningTranSnapshot.children.allObjects as? [DataSnapshot] else {
                completionHandler(false)
                return
            }
            
            for earningTransaction in earningTranSnapshot {
                let amount = earningTransaction.childSnapshot(forPath: "amount").value as! String
                let for_parking_id = earningTransaction.childSnapshot(forPath: "for_parking_id").value as! String
                var from = earningTransaction.childSnapshot(forPath: "from").value as! String
                var to = earningTransaction.childSnapshot(forPath: "to").value as! String
                let timestamp = earningTransaction.childSnapshot(forPath: "timestamp").value as! Double
                
                let timestamp_str = self.convertTimestamp(serverTimestamp: timestamp)
                print(timestamp_str)
                
                let transId = earningTransaction.key
                
                DataService.instance.getUserDataById(forUser: from, completionHandler: { (success, user) in
                    if success {
                        from = (user?.Name)!
                        
                        DataService.instance.getUserDataById(forUser: to, completionHandler: { (success, user) in
                            if success {
                                to = (user?.Name)!
                                
                                let transaction = Transaction.init(amount: amount, for_parking_id: for_parking_id, from: from, to: to, transId: transId, timestamp: timestamp_str)
                                
                                self.earningTransactions[transId] = transaction
                            }
                        })
                    }
                })
                
                
                
                print(amount)
                print(for_parking_id)
                print(from)
                print(to)
            }
            
        }
        completionHandler(true)
    }
    
    private func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd EE, MMM yyyy, h:mm a"  //"EEEE, MMM d, yyyy, h:mm a" 
        
//        formatter.dateStyle = .full
//        formatter.timeStyle = .short
        
        return formatter.string(from: date as Date)
    }
    
    func getBalanceTransactions(completionHandler : @escaping (_ complete : Bool) -> ()) {
        REF_USER_BALANCE_TRANSACTION.observe(.value) { (balanceTranSnapshot) in
            guard let balanceTranSnapshot = balanceTranSnapshot.children.allObjects as? [DataSnapshot] else {
                completionHandler(false)
                return
            }
            
            for balanceTransaction in balanceTranSnapshot {
                let amount = balanceTransaction.childSnapshot(forPath: "amount").value as! String
                let for_parking_id = balanceTransaction.childSnapshot(forPath: "for_parking_id").value as! String
                var from = balanceTransaction.childSnapshot(forPath: "from").value as! String
                var to = balanceTransaction.childSnapshot(forPath: "to").value as! String
                let timestamp = balanceTransaction.childSnapshot(forPath: "timestamp").value as! Double
                
                let timestamp_str = self.convertTimestamp(serverTimestamp: timestamp)
                print(timestamp_str)
                
                let transId = balanceTransaction.key
                
                if to == "wallet" {
                    let transaction = Transaction.init(amount: amount, for_parking_id: for_parking_id, from: from, to: to, transId: transId, timestamp: timestamp_str)
                    
                    self.balanceTransactions[transId] = transaction
                } else {
                    DataService.instance.getUserDataById(forUser: from, completionHandler: { (success, user) in
                        if success {
                            from = (user?.Name)!
                            
                            DataService.instance.getUserDataById(forUser: to, completionHandler: { (success, user) in
                                if success {
                                    to = (user?.Name)!
                                    
                                    let transaction = Transaction.init(amount: amount, for_parking_id: for_parking_id, from: from, to: to, transId: transId, timestamp: timestamp_str)
                                    
                                    self.balanceTransactions[transId] = transaction
                                }
                            })
                        }
                    })
                }
                
                print(amount)
                print(for_parking_id)
                print(from)
                print(to)
            }
            
        }
        completionHandler(true)
    }
    
}
