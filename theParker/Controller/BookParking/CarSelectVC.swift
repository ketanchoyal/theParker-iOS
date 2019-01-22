//
//  CarSelectVC.swift
//  theParker
//
//  Created by Ketan Choyal on 07/01/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

class CarSelectVC: UIViewController {
    
    public private(set) var markerData : LocationPin?
    
    let date = Date()
    let formatter = DateFormatter()
    
    var booked_until_new_database_str : String!
    var booked_until_new_display_str : String!
    
    @IBOutlet weak var carsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "dd-MM-yyyy h:mm a"
        
        print(markerData?.pinloc as Any)
        
        carsTable.delegate = self
        carsTable.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        DataService.instance.getMyCars { (success) in
            if success {
                self.carsTable.reloadData()
            }
        }
    }
    
    func initData(forMarker markerData : LocationPin) {
        self.markerData = markerData
    }
    
    @IBAction func checkoutTapped(_ sender: Any) {
        //TODO : Add Alert
        if booked_until_new_database_str != nil {
            performSegue(withIdentifier: "bookingReviewVC", sender: self)
        }
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CarSelectVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.myCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "carSelectCell") as? CarSelectCell else { return UITableViewCell() }
        
        let cars = DataService.instance.myCars
        let key = Array(cars.keys)[indexPath.row]
        let car = cars[key]
        
        cell.configureCell(car: car!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cars = DataService.instance.myCars
        let carId = Array(cars.keys)[indexPath.row]
        let by = markerData?.by
        
        //TODO : Make it dynamic
        let for_hours_int = 1.0
        let for_hours_database = String(for_hours_int)
        
        //time in minute the parking is booked for
        let booking_for_amount_of_time = (for_hours_int + 0.15) * 60.0
        let booking_for_amount_of_time_display = for_hours_int * 60.0
        
        let time_now_str = formatter.string(from: self.date)
        let time_now_date = formatter.date(from: time_now_str)
        
        var booked_until_database_str : String?
        var booked_until_database_date : Date?
        var diff : Double = 0
        
        if DataService.instance.selectedPin.booked_until != nil {
            booked_until_database_str = DataService.instance.selectedPin.booked_until
            booked_until_database_date = formatter.date(from: booked_until_database_str!)
            diff = (time_now_date?.timeOfDayInterval(toDate: booked_until_database_date!))!
        }
        
        //Camparision
        
        let booked_until_new_database_date : Date!
        var booked_until_new_display_date: Date!
        let from : String!
        
        if diff > 0 {
            // Add the hours in database time + extra 10 min
            //Time for database
            booked_until_new_database_date = booked_until_database_date?.addingTimeInterval(booking_for_amount_of_time * 60.0)
            //Time for displaying
            booked_until_new_display_date = booked_until_database_date?.addingTimeInterval(booking_for_amount_of_time_display * 60.0)
            
            from = formatter.string(from: booked_until_database_date!)
        } else if diff < 0 {
            //Add the hours in current time + extra 10 min
            //Time for database
            booked_until_new_database_date = time_now_date?.addingTimeInterval(booking_for_amount_of_time * 60.0)
            //Time for displaying
            booked_until_new_display_date = time_now_date?.addingTimeInterval(booking_for_amount_of_time_display * 60.0)
            
            from = formatter.string(from: time_now_date!)
        } else {
            //add the hours in current time + extra 10 min
            //Time for database
            booked_until_new_database_date = time_now_date?.addingTimeInterval(booking_for_amount_of_time * 60.0)
            //Time for displaying
             booked_until_new_display_date = time_now_date?.addingTimeInterval(booking_for_amount_of_time_display * 60.0)
            
            from = formatter.string(from: time_now_date!)
        }
        //Time for database
        booked_until_new_database_str = formatter.string(from: booked_until_new_database_date!)
        //Time for displaying
        booked_until_new_display_str = formatter.string(from: booked_until_new_display_date!)
        
        let currentBooking = Booking.init(by: by!, car: carId, for_hours: for_hours_database, from: from, parking_placeId: (markerData?.pinKey)!)
        
        BookingService.currentBooking = currentBooking
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookingReviewVC = segue.destination as? BookingReviewVC
        bookingReviewVC?.initData(booked_until_database: booked_until_new_database_str, booked_until_display: booked_until_new_display_str)
    }
}
