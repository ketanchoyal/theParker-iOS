//
//  LoginViewController.swift
//  Parker
//
//  Created by Rahul Dhiman on 06/03/18.
//  Copyright © 2018 Rahul Dhiman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import EZYGradientView
import Lottie

class LoginViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet var RootView: UIView!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var TopSignUP: NSLayoutConstraint!
    @IBOutlet weak var TopLogin: NSLayoutConstraint!
    @IBOutlet weak var signuppageWIDTH: NSLayoutConstraint!
    @IBOutlet weak var signuppageHEIGHT: NSLayoutConstraint!
    @IBOutlet weak var signupCONPASS: UITextField!
    @IBOutlet weak var FirebaseLOGINbtn: UIButton!
    @IBOutlet weak var signupPASS: UITextField!
    @IBOutlet weak var firebasesignupBTN: UIButton!
    @IBOutlet weak var signupEmail: UITextField!
    @IBOutlet weak var signupNAme: UITextField!
    @IBOutlet weak var SIGNUPVIEW: UIView!
    @IBOutlet weak var Carconst: NSLayoutConstraint!
    @IBOutlet weak var CarLogoView: UIView!
    @IBOutlet weak var FBbtnView: UIButton!
    @IBOutlet weak var GooglebtnView: UIButton!
    @IBOutlet weak var MainLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var K: UIView!
    @IBOutlet weak var A: UIView!
    @IBOutlet weak var R: UIView!
    @IBOutlet weak var E: UIView!
    @IBOutlet weak var RR: UIView!
    @IBOutlet weak var LGBTNVIEWVIEW: UIView!
    @IBOutlet weak var logbtnviewTRA: NSLayoutConstraint!
    @IBOutlet weak var graforPlus: NSLayoutConstraint!
    @IBOutlet weak var graStackBOT: NSLayoutConstraint!
    @IBOutlet weak var graSTackTop: NSLayoutConstraint!
    @IBOutlet weak var gradientStack: UIStackView!
    @IBOutlet weak var LOGINSTACKVIEW: UIStackView!
    @IBOutlet weak var LOGSTACK: UIStackView!
    @IBOutlet weak var LogStackHEIGHT: NSLayoutConstraint!
    @IBOutlet weak var LogStackWIDTH: NSLayoutConstraint!
    @IBOutlet weak var LoginpageWIDTH: NSLayoutConstraint!
    @IBOutlet weak var LoginpageHEIGHT: NSLayoutConstraint!
    @IBOutlet weak var LottieView: UIView!
    @IBOutlet weak var LoginstackviewBTM: NSLayoutConstraint!
    @IBOutlet weak var LogInStackviewHGT: NSLayoutConstraint!
    @IBOutlet weak var MainLogin: UIButton!
    @IBOutlet weak var MainSIGn: UIButton!
    @IBOutlet weak var LGBTNView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var GradientView: UIView!
    
    let googlepic: UIImage = UIImage(named:"search.png")!
    let facebookpic: UIImage = UIImage(named: "facebook.png")!
    
    var actInd:UIActivityIndicatorView!
    var window: UIWindow?
    var imagePicker:UIImagePickerController!
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        user.resignFirstResponder()
        pass.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    var animationPerformedOnce = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !animationPerformedOnce {
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.Carconst.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            animationPerformedOnce = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.actInd.color = UIColor.white
        if DeviceType.IS_IPHONE_5{
            self.actInd.frame = CGRect(x: 45, y: -8, width: 50.0, height: 50.0)
            
        }
        else {
            self.actInd.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
            self.actInd.center = LGBTNView.center
        }
        
        self.LGBTNView.addSubview(actInd)
        
        self.actInd.isHidden = true
        self.SIGNUPVIEW.isHidden = true
        self.firebasesignupBTN.isHidden = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.animationsLOT()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
        UIApplication.shared.endIgnoringInteractionEvents()
        })
        self.Carconst.constant -= view.bounds.width
        self.CarLogoView.backgroundColor = UIColor.clear
        /*self.GooglebtnView.imageView?.image = self.resizeImage(image: googlepic, targetSize: CGSize(width: 200.0,height: 200.0))*/
        self.GooglebtnView.setImage(self.resizeImage(image: self.googlepic, targetSize: CGSize(width: 40.0, height: 40.0)), for: .normal)
        self.FBbtnView.setImage(self.resizeImage(image: self.facebookpic, targetSize: CGSize(width: 40.0, height: 40.0)), for: .normal)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        if DeviceType.IS_IPHONE_5 {
         self.iphone5SE()
        }
        
        if DeviceType.IS_IPHONE_6 {
            self.iphone678()
        }
        
        if DeviceType.IS_IPHONE_6P {
            self.iphone678P()
        }
        
        if DeviceType.IS_IPHONE_X {
            self.iphoneX()
        }
        
        self.user.delegate = self
        self.pass.delegate = self
        self.addgrad()
        self.Logingrad()
        self.MainSIGn.alpha = 0.5
        
        self.UserImage.layer.borderWidth = 1
        self.UserImage.layer.masksToBounds = false
        self.UserImage.layer.borderColor = UIColor.black.cgColor
        self.UserImage.layer.cornerRadius = self.UserImage.frame.height/2
        self.UserImage.clipsToBounds = true
        
        self.LGBTNView.layer.cornerRadius = 15
        self.LGBTNView.clipsToBounds = true
        
        self.SIGNUPVIEW.layer.cornerRadius = 30
        self.SIGNUPVIEW.clipsToBounds = true
        
        self.loginView.layer.cornerRadius = 30
        self.loginView.clipsToBounds = true
        
        let myColor : UIColor = self.hexStringToUIColor(hex: "#d7d2cc")
        
        self.signupNAme.layer.cornerRadius = 15
        self.signupNAme.clipsToBounds = true
        self.signupNAme.layer.borderColor = myColor.cgColor
        self.signupNAme.layer.borderWidth = 2
        
        self.signupPASS.layer.cornerRadius = 15
        self.signupPASS.clipsToBounds = true
        self.signupPASS.layer.borderColor = myColor.cgColor
        self.signupPASS.layer.borderWidth = 2
        
        self.signupEmail.layer.cornerRadius = 15
        self.signupEmail.clipsToBounds = true
        self.signupEmail.layer.borderColor = myColor.cgColor
        self.signupEmail.layer.borderWidth = 2
        
        
        self.signupCONPASS.layer.cornerRadius = 15
        self.signupCONPASS.clipsToBounds = true
        self.signupCONPASS.layer.borderColor = myColor.cgColor
        self.signupCONPASS.layer.borderWidth = 2
        
        self.user.layer.cornerRadius = 15
        self.user.layer.borderColor = myColor.cgColor
        self.user.layer.borderWidth = 2
        
        self.pass.layer.cornerRadius = 15
        self.pass.layer.borderColor = myColor.cgColor
        self.pass.layer.borderWidth = 2
        
        self.user.clipsToBounds = true
        self.pass.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    @IBAction func loginbtn(_ sender: Any) {
        
        if self.user.text == "" || self.pass.text == "" {
            self.alert(message: "Empty Fields!")
            return
        }
        
        self.actInd.startAnimating()
        self.actInd.isHidden = false
        self.FirebaseLOGINbtn.isHidden = true
        guard let email = user.text else { return }
        guard let pass = pass.text else { return }
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                
                
                self.user.text = ""
                self.pass.text = ""
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "slide") as! SWRevealViewController
                
                //updates the view controller
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
                
            } else {
                self.pass.text = ""
                print("Error logging in: \(error!.localizedDescription)")
                self.alert(message: "Error!, Either email or password is Incorrect")
                self.FirebaseLOGINbtn.isHidden = false
                self.actInd.isHidden = true
               // self.resetForm()
            }
        }
        
    }
    
    
    @IBAction func signInFIrebase(_ sender: UIButton) {
        
        
        
        if self.signupNAme.text == "" || self.signupPASS.text == "" || self.signupEmail.text == "" || self.signupCONPASS.text == "" {
            self.alert(message: "Empty Field!")
            return
        }
        
        if self.signupPASS.text != self.signupCONPASS.text {
            self.alert(message: "Password didn't match!")
            return
        }
        
        
        guard let username = self.signupNAme.text else { return }
        guard let email = self.signupEmail.text else { return }
        guard let pass = self.signupPASS.text else { return }
        guard let image = self.UserImage.image else { return }
   
        self.actInd.startAnimating()
        self.actInd.isHidden = false
        self.firebasesignupBTN.isHidden = true
        
        //Authenticates the user using Firebase DB
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            //if there is no errors and there is user
            if error == nil && user != nil {
                //prints out to terminal and user sign up updated on firebase db
                print("User created!")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "slide") as! SWRevealViewController
                    
                    //updates the view controller
                    self.window?.rootViewController = controller
                    self.window?.makeKeyAndVisible()
                
                // uplod the profile pic to Firebase Storage
                self.uploadProfileImage(image) { url in
                    //check
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                print("User display name changed!")
                                
                                self.saveProfile(username: username,Email: email, profileImageURL: url!) { success in
                                    if success {
                                      
                                    } else {
                                        self.firebasesignupBTN.isHidden = false
                                        self.actInd.isHidden = true
                                        self.resetForm()
                                    }
                                }
                                
                            } else {
                                print("Error: \(error!.localizedDescription)")
                                self.firebasesignupBTN.isHidden = false
                                self.actInd.isHidden = true
                                self.resetForm()
                            }
                        }
                        
                    } else {
                        self.firebasesignupBTN.isHidden = false
                        self.actInd.isHidden = true
                        // Error unable to upload profile image
                        self.resetForm()
                    }
                    
                }
                
            } else {
                self.firebasesignupBTN.isHidden = false
                self.actInd.isHidden = true
                print("Error: \(error!.localizedDescription)")
                self.resetForm()
            }
        }
        
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error Signing Up: Try Again", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        
        //refer to firebase storage and get user id, otherwise return
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //store profile pic under user id = uid
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        //firebase needs image as data convert img to data
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            //if there are no errors and image in metadata
            if error == nil, metaData != nil {
                if let url = metaData?.downloadURL() {
                    completion(url)
                } else {
                    completion(nil)
                }
                // success!
            } else {
                // failed
                completion(nil)
            }
        }
    }
    
    func saveProfile(username:String,Email:String ,profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let databaseRef = Database.database().reference().child("user/\(uid)")
        
        let userObject = [
            "Name": username,
            "Email" : Email,
            "photoURL": profileImageURL.absoluteString,
            "ArrayPins": [String("1"):"Blah blah"]
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
    
    @IBAction func mainLGNBTN(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.animationsLOT()
        })
        
        UIView.transition(with: firebasesignupBTN,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                        self?.firebasesignupBTN.isHidden = true
            }, completion: nil)
        
        UIView.transition(with: FirebaseLOGINbtn,
                          duration: 1.0,
                          options: .transitionFlipFromTop,
                          animations: { [weak self] in
                            self?.FirebaseLOGINbtn.isHidden = false
            }, completion: nil)
        
        UIView.transition(with: MainSIGn,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.MainSIGn.alpha = 0.5
                            self?.MainSIGn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            }, completion: nil)
        UIView.transition(with: MainLogin,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.MainLogin.alpha = 1.0
                            self?.MainLogin.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
            }, completion: nil)
        
        UIView.transition(with: loginView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.loginView.isHidden = false
            }, completion: nil)
        UIView.transition(with: SIGNUPVIEW,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.SIGNUPVIEW.isHidden = true
            }, completion: nil)
        }
    
    @IBAction func mainSIGNBTN(_ sender: UIButton) {
        self.loginView.isHidden = true
        self.SIGNUPVIEW.isHidden = false
        
        UIView.transition(with: firebasesignupBTN,
                          duration: 1.0,
                          options: .transitionFlipFromTop,
                          animations: { [weak self] in
                            self?.firebasesignupBTN.isHidden = false
            }, completion: nil)
        
        UIView.transition(with: FirebaseLOGINbtn,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.FirebaseLOGINbtn.isHidden = true
            }, completion: nil)
        
        UIView.transition(with: MainLogin,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.MainLogin.alpha = 0.5
                            self?.MainLogin.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            }, completion: nil)
        UIView.transition(with: MainSIGn,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.MainSIGn.alpha = 1.0
                            self?.MainSIGn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
            }, completion: nil)
        
        UIView.transition(with: loginView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.loginView.isHidden = true
            }, completion: nil)
        UIView.transition(with: SIGNUPVIEW,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.SIGNUPVIEW.isHidden = false
            }, completion: nil)
    }
    
    @IBAction func ImagePIcker(_ sender: UIButton) {
        self.PickerIMG()
    }
    func PickerIMG(){
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    /*
 
 FACEBOOK AND GOOGLE LOGIN HERE
 
 */
    
    
    
    @IBAction func FBLogin(_ sender: Any) {
        
        
    }
    
    @IBAction func GoogleLogin(_ sender: Any) {
    }
    
    
}
    


extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension LoginViewController{
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
    
    func iphone5SE(){
        self.MainLogoHeight.constant = 280.0
        self.graSTackTop.constant = 40.0
        self.graStackBOT.constant = 60.0
        self.signuppageWIDTH.constant = 315.0
        self.signuppageHEIGHT.constant = 260.0
        self.LoginpageWIDTH.constant = 150.0
        self.LoginpageHEIGHT.constant = 260.0
        self.LogStackWIDTH.constant = 140.0
        self.LogStackHEIGHT.constant = 250.0
        self.LogInStackviewHGT.constant = 30.0
        self.LoginstackviewBTM.constant = 5.0
        self.LOGSTACK.spacing = 0
        self.SIGNUPVIEW.layoutIfNeeded()
        self.gradientStack.layoutIfNeeded()
        self.GradientView.layoutIfNeeded()
        self.LOGINSTACKVIEW.layoutIfNeeded()
        self.loginView.layoutIfNeeded()
        self.LOGSTACK.layoutIfNeeded()
        self.updateViewConstraints()
    }
    func iphone678(){
        self.MainLogoHeight.constant = 280.0
        self.graSTackTop.constant = 40.0
        self.graStackBOT.constant = 60.0
        self.signuppageWIDTH.constant = 315.0
        self.signuppageHEIGHT.constant = 320.0
        self.LoginpageWIDTH.constant = 150.0
        self.LoginpageHEIGHT.constant = 320.0
        self.LogStackWIDTH.constant = 140.0
        self.LogStackHEIGHT.constant = 300.0
        self.LogInStackviewHGT.constant = 60.0
        self.LoginstackviewBTM.constant = 5.0
        self.LOGSTACK.spacing = 30
        self.SIGNUPVIEW.layoutIfNeeded()
        self.gradientStack.layoutIfNeeded()
        self.GradientView.layoutIfNeeded()
        self.LOGINSTACKVIEW.layoutIfNeeded()
        self.loginView.layoutIfNeeded()
        self.LOGSTACK.layoutIfNeeded()
        self.updateViewConstraints()
    }
    func iphone678P(){
        self.logbtnviewTRA.constant = 0
        self.MainLogoHeight.constant = 300
        self.graforPlus.constant = 40.0
        self.LGBTNView.layoutIfNeeded()
        self.GradientView.layoutIfNeeded()
        self.updateViewConstraints()
    }
    
    func iphoneX(){
     /*   self.TopLogin.constant = 350.0
        self.TopSignUP.constant = 300.0
        self.loginView.layoutIfNeeded()
        self.SIGNUPVIEW.layoutIfNeeded()
        self.updateViewConstraints()*/
    }
    
   
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
     
        return false
    }
 
    func animationsLOT(){
        let animations = LOTAnimationView(name: "P")
        let Aanimations = LOTAnimationView(name: "A")
        let Ranimations = LOTAnimationView(name: "R")
        let Kanimations = LOTAnimationView(name: "K")
        let Eanimations = LOTAnimationView(name: "E")
        let RRanimations = LOTAnimationView(name: "R")
        
        
        
        self.lotanime(animations, self.LottieView)
        self.lotanime(Aanimations, self.A)
        self.lotanime(RRanimations, self.RR)
        self.lotanime(Kanimations, self.K)
        self.lotanime(Eanimations, self.E)
        self.lotanime(Ranimations, self.R)
    }
    
    func lotanime(_ animations:LOTAnimationView,_ vview:UIView){
        animations.frame = CGRect(x: 0, y: -30, width: vview.frame.width, height: vview.frame.height * 2.5)
        animations.contentMode = .scaleAspectFit
        vview.addSubview(animations)
        animations.play()
        
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
    
    func addgrad(){
        let gradientView = EZYGradientView()
        gradientView.frame = GradientView.bounds
        gradientView.firstColor = self.hexStringToUIColor(hex: "#000000")
        gradientView.secondColor = self.hexStringToUIColor(hex: "#4B0082")
        gradientView.angleº = 180.0
        gradientView.colorRatio = 0.4
        gradientView.fadeIntensity = 1.0
        gradientView.isBlur = true
        gradientView.blurOpacity = 0.5
        self.GradientView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 1500)
        //self.GradientView.roundCorners(corners: [.bottomLeft], radius: 50)
        
         self.GradientView.insertSubview(gradientView, at: 0)
    }
    
    func Logingrad(){
        let gradientView = EZYGradientView()
        gradientView.frame = LGBTNView.bounds
        gradientView.firstColor = self.hexStringToUIColor(hex: "#111111")
        gradientView.secondColor = self.hexStringToUIColor(hex: "#4B0082")
        gradientView.angleº = 90.0
        gradientView.colorRatio = 0.4
        gradientView.fadeIntensity = 1.5
        gradientView.isBlur = true
        gradientView.blurOpacity = 0.5
        //self.GradientView.roundCorners(corners: [.bottomLeft], radius: 50)
        
        self.LGBTNView.insertSubview(gradientView, at: 0)
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

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.UserImage.image = pickedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}


