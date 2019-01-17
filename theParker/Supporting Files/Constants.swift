//
//  Constants.swift
//  theParker
//
//  Created by Ketan Choyal on 01/01/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import Foundation
import Firebase

let DirectionKey = "AIzaSyAnHtwW9CASe6pD7zS_vVRJCiYoA2omOcg"

let DB_BASE = Database.database().reference()
let DB_USER = DB_BASE.child("user")
//var userID = Auth.auth().currentUser?.uid
var DB_CURRENT_USER = DB_BASE.child("user").child((Auth.auth().currentUser?.uid)!)

public private(set) var REF_BASE = DB_BASE
public private(set) var REF_USER = DB_USER
public private(set) var REF_GLOBAL_PINS = DB_BASE.child("GlobalPins")
public private(set) var REF_CARS = DB_BASE.child("Cars")
public private(set) var REF_USER_PINS : DatabaseReference!
public private(set) var REF_USER_CAR : DatabaseReference!
public private(set) var REF_CURRENT_USER : DatabaseReference!
public private(set) var REF_USER_BALANCE : DatabaseReference!
public private(set) var REF_USER_BALANCE_TRANSACTION : DatabaseReference!
public private(set) var REF_USER_EARNING : DatabaseReference!
public private(set) var REF_USER_EARNING_TRANSACTION : DatabaseReference!

func setUID() {
    let ref = DB_USER.child((Auth.auth().currentUser?.uid)!)
    
    REF_CURRENT_USER = ref
    
    REF_USER_PINS = ref.child("ArrayPins")
    
    REF_USER_CAR = ref.child("MyCars")
    
    REF_USER_BALANCE = ref.child("Wallet/Balance")
    
    REF_USER_EARNING = ref.child("Wallet/Earning")
    
    REF_USER_BALANCE_TRANSACTION = ref.child("Wallet/Balance").child("transactions")
    
    REF_USER_EARNING_TRANSACTION = ref.child("Wallet/Earning").child("transactions")
}
