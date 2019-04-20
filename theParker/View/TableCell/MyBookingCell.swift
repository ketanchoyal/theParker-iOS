//
//  MyBookingCell.swift
//  theParker
//
//  Created by Ketan Choyal on 20/04/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

class MyBookingCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var parkingBookedHourLabel: UILabel!
    
    @IBOutlet weak var parkingBookedFromTimeLabel: UILabel!
    @IBOutlet weak var parkingBookedToTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func locationOfParkingButtonPressed(_ sender: Any) {
        //click to see parking location in map
    }
    
    func configureCell(_ booking : Booking) {
        
        let car = DataService.instance.myCars[booking.car]
        carModelLabel.text = car?.model
        
        parkingBookedHourLabel.text = "Parking Booked for : \(booking.for_hours) Hr."
        setParkingTime(time: booking.from)
    }
    
    func setParkingTime(time : String) -> (){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy h:mm a"
        
        var d = formatter.date(from: time)
        
        formatter.dateFormat = "dd EE, MMM yyyy, h:mm a"
        let time = formatter.string(from: d!)
        time.date_Year_Time { (date, year, time) in
            self.dateLabel.text = date
            self.yearLabel.text = year
            self.parkingBookedFromTimeLabel.text = time
        }
        
        d?.addTimeInterval(1.0 * 60.0 * 60.0)
        let ToTime = formatter.string(from: d!)
        ToTime.date_Year_Time { (_, _, time) in
            self.parkingBookedToTimeLabel.text = time
        }
        
    }

}
