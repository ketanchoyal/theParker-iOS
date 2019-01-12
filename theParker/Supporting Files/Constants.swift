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
let userID = Auth.auth().currentUser?.uid
let DB_CURRENT_USER = DB_BASE.child("user").child(userID!)

public private(set) var REF_BASE = DB_BASE
public private(set) var REF_USER = DB_USER
public private(set) var REF_GLOBAL_PINS = DB_BASE.child("GlobalPins")
public private(set) var REF_GLOBAL_COUNT = DB_BASE.child("count")
public private(set) var REF_CURRENT_USER = DB_CURRENT_USER
public private(set) var REF_USER_PINS = DB_CURRENT_USER.child("ArrayPins")
public private(set) var REF_USER_CAR = DB_CURRENT_USER.child("MyCars")
public private(set) var REF_CARS = DB_BASE.child("Cars")
public private(set) var REF_USER_BALANCE = DB_CURRENT_USER.child("Wallet/Balance")
public private(set) var REF_USER_BALANCETRANSACTION = REF_USER_BALANCE.child("transactions")
public private(set) var REF_USER_EARNING = DB_CURRENT_USER.child("Wallet/Earning")
public private(set) var REF_USER_EARNING_TRANSACTION = REF_USER_EARNING.child("transactions")
