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
    
    func bookParking(booked_until : String, handler : @escaping (_ completeHandler : Bool) -> ()) {
        
        formatter.dateFormat = "dd-MM-yyyy"
        let data = BookingService.currentBooking
        let dateNow_string = formatter.string(from: date)
        let locationId = DataService.instance.selectedPin.pinKey
        
        let ref = REF_GLOBAL_PINS.child(locationId).child("Bookings").child(dateNow_string)
        
        let bookingData : Dictionary<String ,Any> = [
            "by" : data?.by,
            "car" : data?.car,
            "for_hours" : data?.for_hours,
            "from" : data?.from
        ]
        
//        let booking : Dictionary<String, Any> = [
//            "booked_until" : booked_until,
//            ref.childByAutoId() : bookingData
//        ]
    }
}
