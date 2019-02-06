//
//  CircleImage.swift
//  Dev-Chat App
//
//  Created by Ketan Choyal on 09/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        self.setupView()
    }
    
    func setupView() {
        
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
        
    }
    
}
