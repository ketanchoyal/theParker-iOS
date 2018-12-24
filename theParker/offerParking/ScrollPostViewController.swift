//
//  ScrollPostViewController.swift
//  Parker
//
//  Created by Rahul Dhiman on 21/03/18.
//  Copyright © 2018 Rahul Dhiman. All rights reserved.
//

import UIKit
import EZYGradientView
import RKPieChart
import Firebase

class ScrollPostViewController: UIViewController {
 
    
    var timer = Timer()
    
    var handleG:DatabaseHandle?
    var handleU:DatabaseHandle?
    var ref:DatabaseReference?
    var countG:Int?
    var countU:Int?
    
    
    let picker = UIDatePicker()
    let pickerCat = UIPickerView()
    
    @IBOutlet weak var ScrollView: UIScrollView!

    var latlongstring:[Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.scrolling()
        
        // Do any additional setup after loading the view.
    }

      func scrolling(){
        
        if DeviceType.IS_IPHONE_5 {
            self.ScrollView.contentSize = CGSize(width: self.view.bounds.width,height: 780)
        }
        else{
            self.ScrollView.contentSize = CGSize(width: self.view.bounds.width,height: 1000)
            
        }
        self.loadscroll()
    }
    func loadscroll(){
        
        if let pageView = Bundle.main.loadNibNamed("post", owner: self, options: nil)?.first as? post {
           
            
            pageView.handling()
            self.ScrollView.addSubview(pageView)
            
                pageView.frame.size.width = self.ScrollView.bounds.size.width

                let gradientView = EZYGradientView()
            if DeviceType.IS_IPHONE_6P{
                gradientView.frame = CGRect(x:0 ,y:0 ,width: pageView.Gview.bounds.size.width+40,height: pageView.Gview.bounds.size.height)
            }
            else{
                gradientView.frame = pageView.Gview.bounds
                
            }
            
                gradientView.firstColor = self.hexStringToUIColor(hex: "#000000")
                gradientView.secondColor = self.hexStringToUIColor(hex: "#4B0082")
                gradientView.angleº = 180.0
                gradientView.colorRatio = 0.4
                gradientView.fadeIntensity = 1.0
                gradientView.isBlur = true
                gradientView.blurOpacity = 0.5
                //self.GradientView.roundCorners(corners: [.bottomLeft], radius: 50)
                pageView.Gview.insertSubview(gradientView, at: 0)
            
            pageView.PlaceOfferButton.addTarget(self, action: #selector(ScrollPostViewController.FinalSUb(sender:)), for: .touchUpInside)
            pageView.createDatePicker()
            pageView.animationsLOT()
            self.roundCorner(pageView.PlaceOfferButton)
        }
        
    }
    
   
    
}

extension ScrollPostViewController{
    
    
    func fireFetch(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.fetchDetails), userInfo: nil, repeats: true)
    }
    
    @objc func fetchDetails(){
     
        if countG != nil && countU != nil {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let databaseRef = Database.database().reference().child("user/\(uid)/ArrayPins/\(countU!)")
            let databaseRefGlobal = Database.database().reference().child("GlobalPins/\(countG!)")
            
            let userObject = [
                "pinloc": ["lat":self.latlongstring[0],"long":self.latlongstring[1]]
                ] as [String:Any]
            
            let userObject2 = [
                "pinloc": ["lat":self.latlongstring[0],"long":self.latlongstring[1]]
                ] as [String:Any]
            
            databaseRef.updateChildValues(userObject){ error, ref in
                // completion(error == nil)
            }
            databaseRefGlobal.updateChildValues(userObject2){ error, ref in
                //completion(error == nil)
            }
            timer.invalidate()
            
            let editor = self.storyboard?.instantiateViewController(withIdentifier: "slide") as! SWRevealViewController
            self.present(editor, animated: true, completion: nil)
            
        }
        
        
    }
    
    @objc func FinalSUb (sender: UIButton){
        //print("BALLE BALLE BALLE BALLE BALLE")
        self.fireFetch()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.ScrollHandling()
        })
    }
    
    func roundCorner(_ rView:UIButton){
        rView.layer.cornerRadius = 10
        rView.clipsToBounds = true
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
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
        self.present(alertview, animated: true, completion: nil)
        
    }
    
    func ScrollHandling(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.ref = Database.database().reference()
        
        handleG = self.ref?.child("count").child("g").observe(.value, with: { (snapshot) in
            
            if let value1 = snapshot.value as? Int{
                
                self.countG = Int(value1)
            }
            
        })
        
        handleU = self.ref?.child("user").child(uid).child("u").observe(.value, with: { (snapshot) in
            
            
            if let value1 = snapshot.value as? Int{
                
                self.countU = Int(value1)
            }
            
        })
    }
}



