import UIKit
import Firebase
import SwiftyJSON
import Alamofire
import EZYGradientView

class SideBarVC: UIViewController {
    
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

        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
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
        
        self.ProfileName.text = self.preName
        self.ProfileEmail.text = self.preEmail
        // Do any additional setup after loading the view.
        
        self.scheduledTimerWithTimeInterval()
       
        
        
    }

    @IBAction func logout(_ sender: Any) {
        try! Auth.auth().signOut()
//        userID = nil
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

extension SideBarVC{
    
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
        gradientView.firstColor = HextoUIColor.instance.hexString(hex: "#111111")
        gradientView.secondColor = HextoUIColor.instance.hexString(hex: "#4B0082")
        gradientView.angleº = 180.0
        gradientView.colorRatio = 0.4
        gradientView.fadeIntensity = 1.0
        gradientView.isBlur = true
        gradientView.blurOpacity = 0.5
        //self.GradientView.roundCorners(corners: [.bottomLeft], radius: 50)
        
        self.StackBG.insertSubview(gradientView, at: 0)
    }
}

extension SideBarVC {
    func handling(){
        
        DispatchQueue.main.async {
            // Async tasks
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            self.ref = Database.database().reference()
            //Going deep into firebase hierarchy
            self.handleName = self.ref?.child("user").child(uid).child("Profile").child("Name").observe(.value, with: { (snapshot) in
                
                if let value = snapshot.value as? String{
                    
                    self.preName = value
                    
                }
            })
            
            self.handleEmail = self.ref?.child("user").child(uid).child("Profile").child("Email").observe(.value, with: { (snapshot) in
                
                if let value = snapshot.value as? String{
                    
                    self.preEmail = value
                    
                }
                
            })
            
            self.handleImgUrl = self.ref?.child("user").child(uid).child("Profile").child("photoURL").observe(.value, with: { (snapshot) in
                
                if let value = snapshot.value as? String{
                    
                    self.preImgUrl = value
                    
                }
                
            })
        }
    }
    
}

extension SideBarVC {
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
