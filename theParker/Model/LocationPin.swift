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
    public var price_hourly : Int = 0
    public var price_daily : Int = 0
    public var price_weekly : Int = 0
    public var price_monthly : Int = 0
    public var type : String = "Car Port"
    public var availability : String = ""
    public var visibility : String = ""
    public var numberofspot : Int = 0
    public var features : [String]!
    public var pinloc : [Double] = []
    public var photos : [UIImage]!
    public var pinKey : String = ""
}
