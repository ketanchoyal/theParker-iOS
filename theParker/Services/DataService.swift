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
let DB_CURRENT_USER = DB_BASE.child("user").child(userID!)

class DataService {
    static let instance = DataService()
    
    static var pinToUpload = LocationPin()
    
    public private(set) var REF_BASE = DB_BASE
    public private(set) var REF_USER = DB_USER
    public private(set) var REF_GLOBAL_PINS = DB_BASE.child("GlobalPins")
    public private(set) var REF_GLOBAL_COUNT = DB_BASE.child("count")
    public private(set) var REF_CURRENT_USER = DB_CURRENT_USER
    public private(set) var REF_USER_PINS = DB_CURRENT_USER.child("ArrayPins")
    public private(set) var REF_USER_BALANCE = DB_CURRENT_USER.child("Wallet").child("Balance")
    public private(set) var REF_USER_EARNING = DB_CURRENT_USER.child("Wallet").child("Earning")
    
    var Name : String!
    var Email : String!
    var photoURL : String!
    var PhoneNumber : String!
    
    func getUserData(completionHandler : @escaping (_ completion : Bool,_ user : User) -> ()) {
        var Name : String!
        var Email : String!
        var photoURL : String!
        var PhoneNumber : String!
        
        REF_CURRENT_USER.child("Profile").observeSingleEvent(of: .value) { (userData) in
            guard let userData = userData.value as? [String : AnyObject] else { return }
            
            Name = userData["Name"] as? String
            Email = userData["Email"] as? String
            photoURL = userData["photoURL"] as? String
            //PhoneNumber = userData["number"] as? String
            let user = User.init(Name: Name, Email: Email, photoURL: photoURL, Number: nil)
            completionHandler(true, user)
        }
    }
    
    func createPinLocation(completionhandeler : @escaping (_ completion : Bool) -> ()) {
        let pin = DataService.pinToUpload
        
        let by = pin.by
        let description = pin.description
        let instruction = pin.instructions
        let numberofspot = pin.numberofspot
        let type = pin.type
        let availability = pin.availability
        let price_hourly = pin.price_hourly
        let price_daily = pin.price_daily
        let price_weekly = pin.price_weekly
        let price_monthly = pin.price_monthly
        let visibility = pin.visibility
        
        let Features = pin.features
        let pinloc = pin.pinloc
        let photos = pin.photos
        
        let FeaturesDict : Dictionary<String, Any>
        let count = Features?.count
        if count == 0 || Features == nil {
            FeaturesDict = [
                "1" : ""
            ]
        } else if count == 1 {
            FeaturesDict = [
                "1" : Features![0]
            ]
        } else if count == 2 {
            FeaturesDict = [
                "1" : Features![0],
                "2" : Features![1]
            ]
        } else if count == 3 {
            FeaturesDict = [
                "1" : Features![0],
                "2" : Features![1],
                "3" : Features![2]
            ]
        } else {
            FeaturesDict = [
                "1" : Features![0],
                "2" : Features![1],
                "3" : Features![2],
                "4" : Features![3]
            ]
        }
        
        let pinlocDict : Dictionary<String , Any> = [
            "lat" : pinloc[0],
            "long" : pinloc[1]
        ]
        
        let pinDetails = [
            "Features" : FeaturesDict,
            "pinloc" : pinlocDict,
            "by" : by,
            "description" : description,
            "instructions" : instruction,
            "numberofspot" : numberofspot,
            "availability" : availability,
            "price_hourly" : price_hourly,
            "price_daily" : price_daily,
            "price_weekly" : price_weekly,
            "price_monthly" : price_monthly,
            "visibility" : visibility,
            "type" : type
            ] as [String : Any]
        
        REF_GLOBAL_PINS.childByAutoId().updateChildValues(pinDetails) { (error, ref) in
            if error == nil {
                let key = ref.key
                self.REF_USER_PINS.child(key!).setValue(key!)
                completionhandeler(true)
            } else {
                completionhandeler(false)
            }
        }
        
    }
    
}
