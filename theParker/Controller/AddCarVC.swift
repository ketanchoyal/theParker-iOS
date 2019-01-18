//
//  AddVehicleVC.swift
//  theParker
//
//  Created by Ketan Choyal on 30/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit
import Firebase

class AddCarVC: UIViewController {

    @IBOutlet weak var vehicleModelTextField: UnderlineTextField!
    @IBOutlet weak var vehicleYearTextField: UnderlineTextField!
    @IBOutlet weak var vehicleColorTextField: UnderlineTextField!
    @IBOutlet weak var vehicleLicenceNoTextField: UnderlineTextField!
    
    var car : Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func cancelPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addVehicleTapped(_ sender: Any) {
        addDetails()
    }
    
    
    
}

extension AddCarVC {
    
    func addDetails() {
        let model = vehicleModelTextField.text
        let year = vehicleYearTextField.text
        let color = vehicleColorTextField.text
        let licence_plate = vehicleLicenceNoTextField.text
        
        if (model?.isBlank)! || (year?.isBlank)! || (color?.isBlank)! || (licence_plate?.isBlank)! {
            alert(message: "Please fill all the information")
        } else {
            let car = Car.init(model: model!, licence_plate: licence_plate!, color: color!, of: (Auth.auth().currentUser?.uid)!, year: year!)
            
            DataService.instance.addCar(car : car) { (success) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.alert(message: "Please try Again")
                }
            }
        }
        
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
