//
//  DataService.swift
//  theParker
//
//  Created by Ketan Choyal on 30/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import Foundation
import Firebase
import GoogleMaps

enum detailFor {
    case booking
    case justdetails
}

class DataService {
    static let instance = DataService()
    
    static var pinToUpload = LocationPin()
    
    var globalPins = [String : LocationPin]()
    var markers = [String : GMSMarker]()
    var myPins = [String : LocationPin]()
    var myPinMarkers = [String : GMSMarker]()
    var myCars = [String : Car]()
    
    var selectedPin = LocationPin()
    
    let date = Date()
    let formatter = DateFormatter()
    
    var Name : String!
    var Email : String!
    var photoURL : String!
    var PhoneNumber : String!
    
    func getUserData(completionHandler : @escaping (_ completion : Bool,_ user : User?) -> ()) {
        var Name : String!
        var Email : String!
        var photoURL : String!
        var PhoneNumber : String!
        
        REF_CURRENT_USER.child("Profile").observeSingleEvent(of: .value) { (userData) in
            guard let userData = userData.value as? [String : AnyObject] else {
                completionHandler(false, nil)
                return }
            
            Name = userData["Name"] as? String
            Email = userData["Email"] as? String
            photoURL = userData["photoURL"] as? String
            //PhoneNumber = userData["number"] as? String
            let user = User.init(Name: Name, Email: Email, photoURL: photoURL, Number: nil)
            completionHandler(true, user)
        }
    }
    
    func createPinLocation(completionhandeler : @escaping (_ completion : Bool) -> ()) {
        let pin = DataService.pinToUpload
        
        let by = pin.by
        let description = pin.description
        let instruction = pin.instructions
        let numberofspot = pin.numberofspot
        let type = pin.type
        let availability = pin.availability
        let price_hourly = pin.price_hourly
        let price_daily = pin.price_daily
        let price_weekly = pin.price_weekly
        let price_monthly = pin.price_monthly
        let visibility = pin.visibility
        let address = pin.address
        let mobile = pin.mobile
        
        let Features = pin.features
        let pinloc = pin.pinloc
        let photos = pin.photos
        
        let FeaturesDict : Dictionary<String, Any>
        let count = Features?.count
        if count == 0 || Features == nil {
            FeaturesDict = [
                "abc" : "No Features"
            ]
        } else if count == 1 {
            FeaturesDict = [
                "abc" : Features![0]
            ]
        } else if count == 2 {
            FeaturesDict = [
                "abc" : Features![0],
                "xyz" : Features![1]
            ]
        } else if count == 3 {
            FeaturesDict = [
                "abc" : Features![0],
                "xyz" : Features![1],
                "pqr" : Features![2]
            ]
        } else {
            FeaturesDict = [
                "abc" : Features![0],
                "xyz" : Features![1],
                "pqr" : Features![2],
                "mno" : Features![3]
            ]
        }
        
        let pinlocDict : Dictionary<String , Any> = [
            "lat" : pinloc[0],
            "long" : pinloc[1]
        ]
        
        let pinDetails = [
            "Features" : FeaturesDict,
            "pinloc" : pinlocDict,
            "by" : by,
            "description" : description,
            "instructions" : instruction,
            "numberofspot" : numberofspot,
            "availability" : availability,
            "price_hourly" : price_hourly,
            "price_daily" : price_daily,
            "price_weekly" : price_weekly,
            "price_monthly" : price_monthly,
            "visibility" : visibility,
            "type" : type,
            "address" : address,
            "mobile" : mobile
            ] as [String : Any]
        
        let key = REF_GLOBAL_PINS.childByAutoId().key
        
//        REF_GLOBAL_PINS.childByAutoId().updateChildValues(pinDetails) { (error, ref) in
//            if error == nil {
//                let key = ref.key
//                REF_USER_PINS.child(key!).setValue(key!)
//                completionhandeler(true)
//            } else {
//                completionhandeler(false)
//            }
//        }
        
        REF_GLOBAL_PINS.child(key!).updateChildValues(pinDetails) { (error, ref) in
            if error == nil {
                completionhandeler(true)
            } else {
                completionhandeler(false)
                return
            }
        }
        REF_USER_PINS.child(key!).setValue(key!)
        
    }
    
    func getGlobalLocationPins(completionHandler : @escaping (_ complete : Bool) -> ()) {
        REF_GLOBAL_PINS.observe(.value) { (globalPinSnapshot) in
            guard let globalPinSnapshot = globalPinSnapshot.children.allObjects as? [DataSnapshot] else {
                completionHandler(false)
                return }
            
            //print(globalPinSnapshot)
            
            for globalPin in globalPinSnapshot {
                let availability = globalPin.childSnapshot(forPath: "availability").value as! String
                let by = globalPin.childSnapshot(forPath: "by").value as! String
                let description = globalPin.childSnapshot(forPath: "description").value as! String
                let instructions = globalPin.childSnapshot(forPath: "instructions").value as! String
                let numberofspot = globalPin.childSnapshot(forPath: "numberofspot").value as! String
                let price_daily = globalPin.childSnapshot(forPath: "price_daily").value as! String
                let price_hourly = globalPin.childSnapshot(forPath: "price_hourly").value as! String
                let price_monthly = globalPin.childSnapshot(forPath: "price_monthly").value as! String
                let price_weekly = globalPin.childSnapshot(forPath: "price_weekly").value as! String
                let type = globalPin.childSnapshot(forPath: "type").value as! String
                let visibility = globalPin.childSnapshot(forPath: "visibility").value as! String
                let address = globalPin.childSnapshot(forPath: "address").value as! String
                let mobile = globalPin.childSnapshot(forPath: "mobile").value as! String
                
                var Features = [String]()
                if let Features_Snapshot = globalPin.childSnapshot(forPath: "Features").value as? [String : String] {
                    for (_,feature) in Features_Snapshot {
                        Features.append(feature)
                    }
                }
                
                print(Features)
                
                let pinloc_Snapshot = globalPin.childSnapshot(forPath: "pinloc").value as? [String : Double]
                var pinloc = [Double]()
                
                var lat : Double = 0.0
                var long : Double = 0.0
                
                
                for (key, value) in pinloc_Snapshot! {
                    if key == "lat" {
                       lat = value
                    }
                    if key == "long" {
                        long = value
                    }
                }
                
                pinloc.append(lat)
                pinloc.append(long)
                
                print(pinloc)
                
                let pinKey = globalPin.key
                
                let locationPin = LocationPin(by: by, description: description, instructions: instructions, price_hourly: price_hourly, price_daily: price_daily, price_weekly: price_weekly, price_monthly: price_monthly, type: type, availability: availability, visibility: visibility, numberofspot: numberofspot, features: Features, pinloc: pinloc, photos: nil, pinKey: pinKey, booked_until : nil, address : address, mobile : mobile)
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(lat, long)
                marker.userData = locationPin
//                marker.snippet = "₹\(price_hourly)"
//                marker.icon = UIImage(named: "location_pin")
//                marker.title = ""
                self.markers[pinKey] = marker
                
                self.globalPins[pinKey] = locationPin
            }
            completionHandler(true)
        }
    }
    
    //Get parking details from location id
    func getPindataById(for id : String, get : detailFor ,handler : @escaping (_ complete : Bool) -> ()) {
        REF_GLOBAL_PINS.child(id).observe(.value) { (pinSnapshot) in
            guard let pinSnapshot = pinSnapshot.value as? [String : Any] else {
                handler(false)
                return }
            
            let availability = pinSnapshot["availability"] as! String
            let by = pinSnapshot["by"] as! String
            let description = pinSnapshot["description"] as! String
            let instructions = pinSnapshot["instructions"] as! String
            let numberofspot = pinSnapshot["numberofspot"] as! String
            let price_daily = pinSnapshot["price_daily"] as! String
            let price_hourly = pinSnapshot["price_hourly"] as! String
            let price_monthly = pinSnapshot["price_monthly"] as! String
            let price_weekly = pinSnapshot["price_weekly"] as! String
            let type = pinSnapshot["type"] as! String
            let visibility = pinSnapshot["visibility"] as! String
            let address = pinSnapshot["address"] as! String
            let mobile = pinSnapshot["mobile"] as! String
            
            var Features = [String]()
            let features = pinSnapshot["Features"] as! [String : String]
            
            for (_, feature) in features {
                Features.append(feature)
            }
            
            let pinloc_Snapshot = pinSnapshot["pinloc"] as! [String : Double]
            var pinloc = [Double]()
            
            var lat : Double = 0.0
            var long : Double = 0.0
            
            for (key, value) in pinloc_Snapshot {
                if key == "lat" {
                    lat = value
                }
                if key == "long" {
                    long = value
                }
            }
            pinloc.append(lat)
            pinloc.append(long)
            
            if get == .booking {
                var booked_until : String!
                
                self.formatter.dateFormat = "dd-MM-yyyy"
                let date = self.formatter.string(from: self.date)
                
                print(date)
                
                REF_GLOBAL_PINS.child(id).observeSingleEvent(of: .value, with: { (bookingSnapshot) in
                    if bookingSnapshot.hasChild("Bookings") {
                        if bookingSnapshot.childSnapshot(forPath: "Bookings").hasChild(date) {
                            //                 if there is current date node then obviously there will be "booked_until" node
                            //                        if bookingSnapshot.childSnapshot(forPath: "Bookings").childSnapshot(forPath: date).hasChild("booked_until") {
                            booked_until = bookingSnapshot.childSnapshot(forPath: "Bookings").childSnapshot(forPath: date).childSnapshot(forPath: "booked_until").value as? String
                            print(booked_until!)
                            
                            let locationPin = LocationPin(by: by, description: description, instructions: instructions, price_hourly: price_hourly, price_daily: price_daily, price_weekly: price_weekly, price_monthly: price_monthly, type: type, availability: availability, visibility: visibility, numberofspot: numberofspot, features: Features, pinloc: pinloc, photos: nil, pinKey: id, booked_until : booked_until, address : address, mobile : mobile)
                            
                            DataService.instance.selectedPin = locationPin
                            
                            handler(true)
                            
                            //                        } else {
                            //                            handler(true)
                            //                            booked_until = nil }
                        } else {
                            handler(true)
                            booked_until = nil }
                    } else {
                        handler(true)
                        booked_until = nil }
                })
            }
            
            else if get == .justdetails {
                let locationPin = LocationPin(by: by, description: description, instructions: instructions, price_hourly: price_hourly, price_daily: price_daily, price_weekly: price_weekly, price_monthly: price_monthly, type: type, availability: availability, visibility: visibility, numberofspot: numberofspot, features: Features, pinloc: pinloc, photos: nil, pinKey: id, booked_until : nil, address : address, mobile : mobile)
                
                self.myPins[id] = locationPin
                
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2DMake(lat, long)
                marker.userData = locationPin
                //                marker.snippet = "₹\(price_hourly)"
                //                marker.icon = UIImage(named: "location_pin")
                //                marker.title = ""
                self.myPinMarkers[id] = marker
                handler(true)
            }
            
            
        }
    }
    
    func addCar(car : Car, handler : @escaping (_ complete : Bool) -> ()) {
        let car = [
            "color" : car.color,
            "licence_plate" : car.licence_plate,
            "of" : car.of,
            "year" : car.year,
            "model" : car.model
        ] as [String : Any]
        
        REF_CARS.childByAutoId().updateChildValues(car) { (error, ref) in
            if error == nil {
                REF_USER_CAR.child(ref.key!).setValue(ref.key!)
                handler(true)
            } else {
                handler(false)
            }
        }
    }
    
    func deleteCar(ofId id : String, handler : @escaping (_ complete : Bool) -> ()) {
        REF_USER_CAR.child(id).removeValue { (error, ref) in
            if error == nil {
                REF_CARS.child(id).removeValue(completionBlock: { (error, ref) in
                    if error == nil {
                        handler(true)
                    } else {
                        handler(false)
                    }
                })
            } else {
                handler(false)
            }
        }
        
    }
    
    func getMyCars(handler : @escaping (_ complete : Bool) -> ()) {
        REF_USER_CAR.observe(.value) { (carsSnapshot) in
            guard let carsSnapshot = carsSnapshot.value as? [String : Any] else {
                handler(false)
                return }
            
            for (key, _) in carsSnapshot {
                REF_CARS.child(key).observe(.value, with: { (carSnapshot) in
                    guard let carData = carSnapshot.value as? [String : AnyObject] else {
                        handler(false)
                        return }
                    
                    let car = Car.init(model: carData["model"] as! String, licence_plate: carData["licence_plate"] as! String, color: carData["color"] as! String, of: carData["of"] as! String, year: carData["year"] as! String)
                    
                    self.myCars[key] = car
                })
            }
            handler(true)
        }
    }
    
    //Get user profile from id
    func getUserDataById(forUser id : String, completionHandler : @escaping (_ completion : Bool,_ user : User?) -> ()) {
        var Name : String!
        var Email : String!
        var photoURL : String!
        var PhoneNumber : String!
        
        REF_USER.child(id).child("Profile").observeSingleEvent(of: .value) { (userData) in
            guard let userData = userData.value as? [String : AnyObject] else {
                completionHandler(false, nil)
                return }
            
            Name = userData["Name"] as? String
            Email = userData["Email"] as? String
            photoURL = userData["photoURL"] as? String
            //PhoneNumber = userData["number"] as? String
            let user = User.init(Name: Name, Email: Email, photoURL: photoURL, Number: nil)
            completionHandler(true, user)
        }
    }
    
    func getMyPins(completionHandler : @escaping(_ completion : Bool) -> ()) {
        REF_CURRENT_USER.child("ArrayPins").observe(.value) { (myPinData) in
            guard let pinKey = myPinData.value as? [String : String] else {
                completionHandler(false)
                return
            }
            for(_,key) in pinKey {
                self.getPindataById(for: key, get: .justdetails, handler: { (_) in })
            }
        }
        completionHandler(true)
    }
    
}
