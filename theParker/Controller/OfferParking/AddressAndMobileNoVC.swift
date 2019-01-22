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
        pinLocationVC_Count = 1
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeTap(_ recognizer : UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
