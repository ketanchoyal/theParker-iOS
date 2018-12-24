//
//  ProfileDetailViewController.swift
//  Parker
//
//  Created by Rahul Dhiman on 12/03/18.
//  Copyright © 2018 Rahul Dhiman. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import Alamofire
import EZYGradientView

class ProfileDetailViewController: UIViewController {
    
    var timer = Timer()
    var timerImg = Timer()
    var count = 0
    
    var handleName:DatabaseHandle?
    var handleEmail:DatabaseHandle?
    var handleImgUrl:DatabaseHandle?
    var ref:DatabaseReference?
    var preName:String? = ""
    var preEmail:String? = ""
    var preImgUrl:String? = ""
    var ProfileImgUrl:String? = ""
    
    @IBOutlet weak var profileIMGWIDTH: NSLayoutConstraint!
    @IBOutlet weak var ProfileIMGHEIGHT: NSLayoutConstraint!
    @IBOutlet weak var MainStackTop: NSLayoutConstraint!
    @IBOutlet weak var StackBG: UIView!
    @IBOutlet var BackgroundView: UIView!
    @IBOutlet weak var ImageBG: UIView!
    
    @IBOutlet weak var indi: UIActivityIndicatorView!
    
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var ProfileName: UILabel!
    
    @IBOutlet weak var ProfileEmail: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fixIphone5()
        self.fixiphone6()
    }
    
    
    override func viewDidLoad() {
        self.addgrad()
    
        self.ImageBG.layer.cornerRadius = 20
        self.ImageBG.clipsToBounds = true
        
        self.ImageBG.backgroundColor = .clear
        
        
        self.indi.isHidden = false
        super.viewDidLoad()
        self.handling()
        //self.fixIphone5()
        
        self.StackBG.layer.cornerRadius = 10
        self.StackBG.clipsToBounds = true
        
        self.ProfileImage.layer.borderColor = UIColor.black.cgColor
        self.ProfileImage.layer.borderWidth = 2
        
        if !DeviceType.IS_IPHONE_5 || !DeviceType.IS_IPHONE_6{
        self.ProfileImage.layer.cornerRadius = self.ProfileImage.frame.width/2
            self.ProfileImage.clipsToBounds = true}
        
        
        self.ProfileName.text = self.preName
        self.ProfileEmail.text = self.preEmail
        // Do any additional setup after loading the view.
        
        self.scheduledTimerWithTimeInterval()
       
        
        
    }

    @IBAction func logout(_ sender: Any) {
         try! Auth.auth().signOut()
    }
    
    func ImportingProfileImage(){
        let rqsturl = URL(string: self.ProfileImgUrl!)!
        let session = URLSession.shared
        let request = URLRequest(url: rqsturl)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("error erroe error error error")
            }
            else {
                if let imageData = try? Data(contentsOf: rqsturl) {
                    print("MAIN MAIN MAIN MAIN MAIN")
                    print(imageData)
                    DispatchQueue.main.async {
                        self.ProfileImage.image = UIImage(data: imageData)
                         self.indi.isHidden = true
                    }
                    
                }
            }
           
        }
        task.resume()
        
    }
    

}

extension ProfileDetailViewController{
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
            DispatchQueue.main.async {
                
                //  self.UISetup(enable: true)
            }
        }))
        self.present(alertview, animated: true, completion: nil)
        
    }
    
    func addgrad(){
        let gradientView = EZYGradientView()
        gradientView.frame = self.StackBG.bounds
        gradientView.firstColor = self.hexStringToUIColor(hex: "#111111")
        gradientView.secondColor = self.hexStringToUIColor(hex: "#4B0082")
        gradientView.angleº = 180.0
        gradientView.colorRatio = 0.4
        gradientView.fadeIntensity = 1.0
        gradientView.isBlur = true
        gradientView.blurOpacity = 0.5
        //self.GradientView.roundCorners(corners: [.bottomLeft], radius: 50)
        
        self.StackBG.insertSubview(gradientView, at: 0)
    }
}

extension ProfileDetailViewController {
    func handling(){
        
        DispatchQueue.main.async {
            // Async tasks
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            self.ref = Database.database().reference()
            //Going deep into firebase hierarchy
            self.handleName = self.ref?.child("user").child(uid).child("Name").observe(.value, with: { (snapshot) in
                
                if let value = snapshot.value as? String{
                    
                    
                    
                    self.preName = value
                    
                }
            })
            
            self.handleEmail = self.ref?.child("user").child(uid).child("Email").observe(.value, with: { (snapshot) in
                
                if let value = snapshot.value as? String{
                    
                    self.preEmail = value
                    
                }
                
            })
            
            self.handleImgUrl = self.ref?.child("user").child(uid).child("photoURL").observe(.value, with: { (snapshot) in
                
                if let value = snapshot.value as? String{
                    
                    self.preImgUrl = value
                    
                }
                
            })
        }
    }
    
}

extension ProfileDetailViewController {
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.UserDetails), userInfo: nil, repeats: true)
    }
    
    @objc func UserDetails(){
        
        if self.preName == "" || self.preEmail == "" || self.preImgUrl == "" {
            self.ProfileName.text = String("Name")
            self.ProfileEmail.text = String("Email")
        }
        else{
            self.ProfileName.text = self.preName
            self.ProfileEmail.text = self.preEmail
            self.ProfileImgUrl = self.preImgUrl
            self.ImportingProfileImage()
            self.timer.invalidate()
        }
        
    }
}

extension ProfileDetailViewController{
    func fixIphone5(){
        if DeviceType.IS_IPHONE_5 {
            if count == 0{
            self.MainStackTop.constant -= 20
            self.profileIMGWIDTH.constant -= 25
            self.ProfileIMGHEIGHT.constant -= 25
            self.ProfileImage.layer.cornerRadius = self.profileIMGWIDTH.constant/2
            self.ProfileImage.clipsToBounds = true
                count += 1
            }
        }
    }
    func fixiphone6(){
        if DeviceType.IS_IPHONE_6{
            if count == 0{
            self.MainStackTop.constant -= 10
            self.profileIMGWIDTH.constant -= 20
            self.ProfileIMGHEIGHT.constant -= 20
            self.ProfileImage.layer.cornerRadius = self.profileIMGWIDTH.constant/2
            self.ProfileImage.clipsToBounds = true
                count += 1
        }
        }
    }
}
