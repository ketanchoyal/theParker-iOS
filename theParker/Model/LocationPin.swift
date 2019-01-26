//
//  LocationPin.swift
//  theParker
//
//  Created by Ketan Choyal on 31/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import Foundation
import Firebase

class LocationPin {
    public var by : String = (Auth.auth().currentUser?.uid)!
    public var description : String = "No Description"
    public var instructions : String = "No special instructions"
    public var price_hourly : String = "0"
    public var price_daily : String = "0"
    public var price_weekly : String = "0"
    public var price_monthly : String = "0"
    public var type : String = "Car Port"
    public var availability : String = ""
    public var visibility : String = ""
    public var numberofspot : String = "0"
    public var features : [String]!
    public var pinloc : [Double] = []
    public var photos : [UIImage]!
    public var pinKey : String = ""
    public var booked_until : String!
    public var address : String = ""
    public var mobile : String = ""
    
    init() {}
    
    init(by : String, description : String, instructions : String, price_hourly : String, price_daily : String, price_weekly : String, price_monthly : String, type : String, availability : String, visibility : String, numberofspot : String, features : [String]!, pinloc : [Double], photos : [UIImage]!, pinKey : String, booked_until : String!, address : String, mobile : String) {
        self.by = by
        self.description = description
        self.instructions = instructions
        self.price_hourly = price_hourly
        self.price_daily = price_daily
        self.price_weekly = price_weekly
        self.price_monthly = price_monthly
        self.type = type
        self.availability = availability
        self.visibility = visibility
        self.numberofspot = numberofspot
        self.features = features
        self.pinloc = pinloc
        self.photos = photos
        self.pinKey = pinKey
        self.booked_until = booked_until
        self.address = address
        self.mobile = mobile
    }
    
}
