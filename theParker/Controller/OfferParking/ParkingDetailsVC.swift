//
//  ParkingDetailsVC.swift
//  theParker
//
//  Created by Ketan Choyal on 27/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class ParkingDetailsVC: UIViewController {

    @IBOutlet weak var parkingTypeSegment: UISegmentedControl!
    @IBOutlet weak var noOfSpot: UnderlineTextField!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var coveredSwitch: UISwitch!
    @IBOutlet weak var securityCameraSwitch: UISwitch!
    @IBOutlet weak var onSiteStaffSwitch: UISwitch!
    @IBOutlet weak var disabledAccessSwitch: UISwitch!
    
//    var pinToUpload : LocationPin?
    
    var parkingType : String = "Other"
    var features : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("pin : \(DataService.pinToUpload)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        
        if parkingTypeSegment.selectedSegmentIndex == UISegmentedControl.noSegment {
            alert(message: "Please select Parking Type")
        } else {
            nextButton.isEnabled = false
            addDetails { (success) in
                if success {
                    self.performSegue(withIdentifier: "additionalDetails", sender: nil)
                    self.nextButton.isEnabled = true
                } else {
                    self.nextButton.isEnabled = true
                }
            }
        }
        
    }
    
    @IBAction func parkingTypeSegmentChanged(_ sender: Any) {
        switch parkingTypeSegment.selectedSegmentIndex {
        case 0:
            parkingType = "Car Port"
            break
        case 1:
            parkingType = "Driveway"
            break
        case 2:
            parkingType = "Garage"
            break
        case 3:
            parkingType = "Other"
            break
        default:
            break
        }
    }
    
    func featureAdd() {
        features = []
        if coveredSwitch.isOn {
            features.append("Covered")
        }
        
        if securityCameraSwitch.isOn {
            features.append("Security Camera")
        }
        
        if onSiteStaffSwitch.isOn {
            features.append("Onsite Staff")
        }
        
        if disabledAccessSwitch.isOn {
            features.append("Disabled Access")
        }
    }
    
    func addDetails(completionhandler : @escaping (_ complete : Bool) -> ()) {
        
        let pin = DataService.pinToUpload
        
        featureAdd()
        pin.features = features
        
        pin.type = parkingType
        
        let numberOfSpot = noOfSpot.text
        
        pin.numberofspot = numberOfSpot!
        
        completionhandler(true)
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
