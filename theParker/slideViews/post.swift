//
//  post.swift
//  Parker
//
//  Created by Rahul Dhiman on 21/03/18.
//  Copyright © 2018 Rahul Dhiman. All rights reserved.
//

import UIKit
import Foundation
import Lottie
import Firebase

class post: UIView, UITextFieldDelegate {
    
     let picker = UIDatePicker()
     var intprice:Double = 0.0
     let date = Date()
     let calendar = Calendar.current
    
    
    var handleCount:DatabaseHandle?
    var handleUserCount:DatabaseHandle?
    var ref:DatabaseReference?
    var count:Int?
    var userCount:Int?
    
     var DataDescription:String = ""
     var DataLocation:String = ""
     var DataCar:String = ""
     var DataMyPrice:String = ""
     var DataTime:String = ""
     var DataTotalPrice:String = ""
    
    
    
    @IBOutlet weak var PlaceDescription: UITextField!
    @IBOutlet weak var PlaceLocation: UITextField!
    @IBOutlet weak var CarInfo: UITextField!
    
    @IBOutlet weak var ChartView: UIView!
    @IBOutlet weak var MyPrice: UITextField!
    @IBOutlet weak var TotalPrice: UILabel!
    @IBOutlet weak var Gview: UIView!
    @IBOutlet weak var stackLead: NSLayoutConstraint!
    
    @IBOutlet weak var TimeRegion: UITextField!
    @IBOutlet weak var LocationPictureButton: UIButton!
    @IBOutlet weak var PlaceOfferButton: UIButton!
    
    @IBOutlet weak var doneInd: UIActivityIndicatorView!
    
    
    @IBAction func DoneButtonDone(_ sender: Any) {
        

        
        
        if PlaceDescription.text != nil {
            DataDescription = PlaceDescription.text!
        }
        
        if PlaceLocation.text != nil {
            DataLocation = PlaceLocation.text!
        }
        
        if CarInfo.text != nil {
            DataCar = CarInfo.text!
        }
        
        if TimeRegion.text != nil {
            DataTime = TimeRegion.text!
        }
        
        if MyPrice.text != nil {
             DataMyPrice = MyPrice.text!
        }
 
        
        if DataDescription == ""{
            self.alert(message: "Description")
            return
        }
        
        else if DataLocation == "" {
            self.alert(message: "Location")
            return
        }
        
        else if DataCar == "" {
            self.alert(message: "Car")
            return
        }
        
        else if DataTime == "" {
            self.alert(message: "time")
            return
        }
        
        else if DataMyPrice == "" {
           self.alert(message: "price")
            return
        }
        
        else {
            let day = self.calendar.component(.day, from: date)
            let month = self.calendar.component(.month, from: date)
            let year = self.calendar.component(.year, from: date)
            doneInd.isHidden = false
            PlaceOfferButton.isHidden = true
            
          guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let databaseRef = Database.database().reference().child("user/\(uid)/ArrayPins/\(userCount!+1)")
            let databaseRefGlobal = Database.database().reference().child("GlobalPins/\(count!+1)")
            let countUser = Database.database().reference().child("count")
            let countmin = Database.database().reference().child("user/\(uid)")
           
            
            
            
            
            let userObject = [
                "Description":DataDescription,
                "Location":DataLocation,
                "Car":DataCar,
                "Time":DataTime,
                "Price":DataTotalPrice,
                "Day":day,
                "Month":month,
                "Year":String(year)
                ] as [String:Any]
            
            let userObject2 = [
                "Description":DataDescription,
                "Location":DataLocation,
                "Car":DataCar,
                "Time":DataTime,
                "Price":DataTotalPrice,
                "Day":day,
                "Month":month,
                "Year":year
                ] as [String:Any]
            
            let userObject3 = [
                "g": count!+1
                ] as [String:Any]
            
            let userObject4 = [
                "u": userCount!+1
                ] as [String:Any]
            
            databaseRef.updateChildValues(userObject){ error, ref in
               // completion(error == nil)
            }
            databaseRefGlobal.updateChildValues(userObject2){ error, ref in
                //completion(error == nil)
            }
            countUser.updateChildValues(userObject3){ error, ref in
                //completion(error == nil)
            }
            countmin.updateChildValues(userObject4){ error, ref in
                //completion(error == nil)
            }
 
        }
    
    
    }
    
    
    func createDatePicker()
    {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //setting up DONE button in toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        TimeRegion.inputAccessoryView = toolbar
        TimeRegion.inputView = picker
        
        picker.datePickerMode = .time
        
    }
    
    @objc func donePressed(){
        
        // Date Format settings
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let dateString = formatter.string(from: picker.date)
        
        UIView.transition(with: TimeRegion,
                          duration: 1.0,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.TimeRegion.text = "\(dateString)"
            }, completion: nil)
        
        TimeRegion.resignFirstResponder()
    }
    
    
   
    
    
    func animationsLOT(){
        let animations = LOTAnimationView(name: "bouncy_mapmaker")
        self.lotanime(animations, ChartView)
        MyPrice.delegate = self
        doneInd.isHidden = true
        
    }
    
    func lotanime(_ animations:LOTAnimationView,_ vview:UIView){
        
        if DeviceType.IS_IPHONE_5{
            animations.frame = CGRect(x: 0, y: 0, width: vview.frame.width-50, height: vview.frame.height-50)
        }
        
        if DeviceType.IS_IPHONE_6 {
            animations.frame = CGRect(x: 20, y: 0, width: vview.frame.width-20, height: vview.frame.height-20)
        }
        
        if DeviceType.IS_IPHONE_6P {
            animations.frame = CGRect(x: 20, y: -10, width: vview.frame.width, height: vview.frame.height)
        }
        
        if DeviceType.IS_IPHONE_X {
            animations.frame = CGRect(x: 0, y: 0, width: vview.frame.width, height: vview.frame.height)
        }
        
        animations.contentMode = .scaleAspectFit
        animations.loopAnimation = true
        vview.addSubview(animations)
        animations.play()
        
    }
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    }
    
    func alert(message:String )
    {
        
        
        
        let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertview.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: {
            action in
            
        }))
        
         self.window?.rootViewController?.present(alertview, animated: true, completion: nil)
        
    }
    
    
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        if MyPrice.text != nil {
            DataMyPrice = MyPrice.text!
        }
        intprice = Double(DataMyPrice)!
        let strprice = intprice + (0.2 * intprice)
        DataTotalPrice = String(strprice)
        TotalPrice.text = DataTotalPrice
        
        
    }
    
    func handling(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.ref = Database.database().reference()
        
        handleCount = self.ref?.child("GlobalPins").observe(.value, with: { (snapshot) in
            
            if let value1 = snapshot.childrenCount as? UInt{
                
                self.count = Int(value1)
            }
            
        })
        
        handleUserCount = self.ref?.child("user").child(uid).child("ArrayPins").observe(.value, with: { (snapshot) in
            
            
            if let value1 = snapshot.childrenCount as? UInt{
                
                self.userCount = Int(value1)
            }
            
        })
    }
    
}
