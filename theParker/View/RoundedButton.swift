//
//  RoundedButton.swift
//  theParker
//
//  Created by Ketan Choyal on 29/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    func setupView() {
        
        
    }
}
