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
    
    var booked_until : String = ""
    var booked_from : String?
    
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
        if booked_until != "" {
            performSegue(withIdentifier: "bookingReviewVC", sender: booked_until)
        }
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bookingReviewVC = segue.destination as? BookingReviewVC
        bookingReviewVC?.initData(booked_until: booked_until)
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
        let for_hours_int = 1
        let for_hours = String(for_hours_int)
        
        let from = formatter.string(from: date)
        let booked_from = formatter.date(from: from)
        
        let currentBooking = Booking.init(by: by!, car: carId, for_hours: for_hours, from: from)
        BookingService.currentBooking = currentBooking
        
        let booked_time = Double(for_hours_int) * 60.0 //time in minute the parking is booked for
        let booked_until_date = booked_from?.addingTimeInterval(booked_time * 60.0)
        
        booked_until = formatter.string(from: booked_until_date!)
        
    }
}
