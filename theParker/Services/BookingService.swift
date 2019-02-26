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
            "from" : data?.from,
            "parking_placeId" : data?.parking_placeId
        ]
        
        let booking = [
            "booked_until" : booked_until_database_str,
            key! : key!
        ]
        //TODO : Cloud Function can be made to add data at multiple places as soon as it is added at only one place
        REF_GLOBAL_BOOKINGS.child(key!).updateChildValues(bookingData as [AnyHashable : Any]) { (error, ref) in
            if error == nil {
                REF_GLOBAL_PINS.child(locationId).child("Bookings").child(dateNow_string).updateChildValues(booking) { (error, ref) in
                    if error == nil {
                        REF_USER_BOOKINGS.child(key!).setValue(key!)
                        handler(true)
                    } else {
                        handler(false)
                    }
                }
            } else {
                handler(false)
            }
        }
        
        
        
    }
}
