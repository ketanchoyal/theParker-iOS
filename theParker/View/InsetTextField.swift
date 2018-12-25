//
//  InsetTextField.swift
//  theParker
//
//  Created by Ketan Choyal on 25/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {
    
    let myColor : UIColor = HextoUIColor.instance.hexString(hex: "#d7d2cc")

    override func awakeFromNib() {
        setupView()
        super.awakeFromNib()
    }
    
    func setupView() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.layer.borderColor = myColor.cgColor
        self.layer.borderWidth = 2
    }

}
