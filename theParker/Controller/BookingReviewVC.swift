//
//  BookingReviewController.swift
//  theParker
//
//  Created by Ketan Choyal on 11/01/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

class BookingReviewVC: UIViewController {
    
    @IBOutlet weak var spotTypeLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var spotPrice: UILabel!
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var carInfoLabel: UILabel!
    
    var booked_until : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Booking Review"

        setUpData()
        
        print(booked_until)
        print(DataService.currentBooking?.from)
    }
    
    func initData(booked_until : String) {
        self.booked_until = booked_until
    }

}

extension BookingReviewVC {
    func setUpData() {
        let bookingData = DataService.currentBooking
        let marker = DataService.instance.selectedPin
        let car = DataService.instance.myCars[(bookingData?.car)!]
        
        spotTypeLabel.text = marker.type
        startLabel.text = bookingData?.from
        endLabel.text = booked_until
        totalPrice.text = "₹ \(marker.price_hourly)" //Add service Charge rs
        spotPrice.text = "₹ \(marker.price_hourly)"
        servicePrice.text = "₹ ??"
        carInfoLabel.text = "\((car?.color)!) \((car?.model)!) (\((car?.year)!)) \((car?.licence_plate)!)"
        
    }
}
