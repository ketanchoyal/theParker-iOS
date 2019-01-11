//
//  BookingService.swift
//  theParker
//
//  Created by Ketan Choyal on 12/01/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import Foundation
import Firebase

class BookingService {
    static let instance = BookingService()
    
    let date = Date()
    let formatter = DateFormatter()
    
    static var currentBooking : Booking?
    
    func bookParking(booked_until_database_str : String, handler : @escaping (_ completeHandler : Bool) -> ()) {
        
        let locationPin = DataService.instance.selectedPin
        let locationId = locationPin.pinKey
        
        self.formatter.dateFormat = "dd-MM-yyyy"
        
        //Child ID
        let dateNow_string = self.formatter.string(from: self.date)
        
        //Generate Random Key without setting actuall Data
        let key = REF_GLOBAL_PINS.child(locationId).childByAutoId().key
        
        let data = BookingService.currentBooking
        let bookingData = [
            "by" : data?.by,
            "car" : data?.car,
            "for_hours" : data?.for_hours,
            "from" : data?.from
        ]
        
        let booking : Dictionary<String, Any> = [
            "booked_until" : booked_until_database_str,
            key! : bookingData
        ]
        
        REF_GLOBAL_PINS.child(locationId).child("Bookings").child(dateNow_string).updateChildValues(booking) { (error, ref) in
            if error == nil {
                handler(true)
            } else {
                handler(false)
            }
        }
        
    }
}
