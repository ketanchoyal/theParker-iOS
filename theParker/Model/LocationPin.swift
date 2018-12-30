//
//  LocationPin.swift
//  theParker
//
//  Created by Ketan Choyal on 31/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import Foundation

struct LocationPin {
    public var by : String
    public var description : String!
    public var instructions : String!
    public var price_hourly : String
    public var type : String
    public var availability : Bool
    public var numberofspot : Int
    public var features : [String]!
    public var pinloc : [Double]
    public var photos : [UIImage]!
    public var pinKey : String
}
