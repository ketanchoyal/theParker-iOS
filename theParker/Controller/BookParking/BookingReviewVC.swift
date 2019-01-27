//
//  BookingReviewController.swift
//  theParker
//
//  Created by Ketan Choyal on 11/01/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit
import Firebase

class BookingReviewVC: UIViewController {
    
    @IBOutlet weak var spotTypeLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var spotPrice: UILabel!
    @IBOutlet weak var servicePrice: UILabel!
    @IBOutlet weak var carInfoLabel: UILabel!
    @IBOutlet weak var activityIndicatior: UIActivityIndicatorView!
    
    var booked_until_database : String!
    var booked_until_display : String!
    
    var transaction : Transaction!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Booking Review"
        activityIndicatior.stopAnimating()
        activityIndicatior.isHidden = true
        setUpData()
        
        print(booked_until_database)
        print(booked_until_display)
        print(BookingService.currentBooking?.from)
    }
    
    func initData(booked_until_database : String, booked_until_display : String) {
        self.booked_until_database = booked_until_database
        self.booked_until_display = booked_until_display
    }
    
    @IBAction func bookParkingTapped(_ sender: Any) {
        activityIndicatior.isHidden = false
        activityIndicatior.startAnimating()
        BookingService.instance.bookParking(booked_until_database_str: booked_until_database) { (success) in
            if success {
                WalletService.instance.parking_purchase_transaction(transaction: self.transaction, handler: { (success) in
                    if success {
                        self.activityIndicatior.stopAnimating()
                        self.gotoParkingBookedVC()
                    } else {
                        self.activityIndicatior.stopAnimating()
                        self.alert(message: "Something went wrong, Try again")
                    }
                })
            } else {
                self.activityIndicatior.startAnimating()
                self.alert(message: "Something went wrong, Try again")
            }
        }
        
    }
    
    func gotoParkingBookedVC() {
        let parkingBookedVC = self.storyboard?.instantiateViewController(withIdentifier: "parkingBookedVC") as? ParkingBookedVC
        parkingBookedVC?.initData(amountPaid: totalPrice.text!)
        present(parkingBookedVC!, animated: true, completion: nil)
    }
    
}

extension BookingReviewVC {
    func setUpData() {
        let bookingData = BookingService.currentBooking
        let marker = DataService.instance.selectedPin
        let car = DataService.instance.myCars[(bookingData?.car)!]
        
        var transaction = Transaction.init(amount: marker.price_hourly, for_parking_id: marker.pinKey, from: (Auth.auth().currentUser?.uid)!, to: marker.by)
        
        self.transaction = transaction
        
        spotTypeLabel.text = marker.type
        startLabel.text = bookingData?.from
        endLabel.text = booked_until_display
        totalPrice.text = "₹ \(marker.price_hourly)" //Add service Charge rs
        spotPrice.text = "₹ \(marker.price_hourly)"
        servicePrice.text = "₹ ??"
        carInfoLabel.text = "\((car?.color)!) \((car?.model)!) (\((car?.year)!)) \((car?.licence_plate)!)"
    }
    
    func alert(message:String )
    {
        let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertview.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: {
            action in
            DispatchQueue.main.async {
                
                //  self.UISetup(enable: true)
            }
        }))
        self.present(alertview, animated: true, completion: nil)
        
    }
}
