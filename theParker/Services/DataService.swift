//
//  DataService.swift
//  theParker
//
//  Created by Ketan Choyal on 30/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let DB_USER = DB_BASE.child("user")

let userID = Auth.auth().currentUser?.uid

class DataService {
    static let instance = DataService()
    
    public private(set) var REF_BASE = DB_BASE
    public private(set) var REF_USER = DB_USER
    public private(set) var REF_CURRENT_USER = DB_USER.child(userID!)
    public private(set) var REF_GLOBAL_PINS = DB_BASE.child("Globalpins")
    public private(set) var REF_GLOBAL_COUNT = DB_BASE.child("count")
    public private(set) var REF_USER_PINS = DB_USER.child(userID!).child("ArrayPins")
    public private(set) var REF_USER_BALANCE = DB_USER.child(userID!).child("Wallet").child("Balance").child("transactions")
    public private(set) var REF_USER_EARNING = DB_USER.child(userID!).child("Wallet").child("Earning").child("transactions")
    
    var Name : String!
    var Email : String!
    var photoURL : String!
    var PhoneNumber : String!
    
    func getUserData(completionHandler : @escaping (_ completion : Bool) -> ()) {
        
        var Name : String!
        var Email : String!
        var photoURL : String!
        var PhoneNumber : String!
        
        REF_CURRENT_USER.child("Name").observe(.value) { (nameSnapshot) in
            guard let N = nameSnapshot.value as? String else { return }
            Name = N
            print(N)
        }
        
        REF_CURRENT_USER.child("Email").observe(.value) { (nameSnapshot) in
            guard let E = nameSnapshot.value as? String else { return }
            Email = E
            print(E)
        }
        
        REF_CURRENT_USER.child("photoURL").observe(.value) { (nameSnapshot) in
            guard let p = nameSnapshot.value as? String else { return }
            photoURL = p
            print(p)
        }
        
//        REF_CURRENT_USER.child("PhoneNumber").observe(.value) { (nameSnapshot) in
//            guard let N = nameSnapshot.value as? String else { return }
//            PhoneNumber = N
//            print(N)
//        }
    }
    
}
