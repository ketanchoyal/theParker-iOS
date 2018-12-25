//
//  RoundedUIView.swift
//  theParker
//
//  Created by Ketan Choyal on 25/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedUIView: UIView {

    @IBInspectable var cornerRadius : CGFloat = 10 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
        super.awakeFromNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }

}
