//
//  AddressAndMobileNoVC.swift
//  theParker
//
//  Created by Ketan Choyal on 23/01/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

class AddressAndMobileNoVC: UIViewController {

    @IBOutlet weak var addressField: UITextView!
    @IBOutlet weak var mobileNoField: UnderlineTextField!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        // Do any additional setup after loading the view.
    }

    func setUpView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }

    @IBAction func continueTapped(_ sender: Any) {
        
        let address = addressField.text
        let mobile = mobileNoField.text
        
        if (address?.isBlank)! || (mobile?.isBlank)! {
            alert(message: "Details are incomplete!")
        } else{
            let pin = DataService.pinToUpload
            pin.address = address!
            pin.mobile = mobile!
            pinLocationVC_Count = 1
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeTap(_ recognizer : UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddressAndMobileNoVC {
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
