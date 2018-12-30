//
//  VehicleInfoCell.swift
//  theParker
//
//  Created by Ketan Choyal on 30/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

@IBDesignable
class VehicleInfoCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 0
        self.layer.borderWidth = 3
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        let borderColor: UIColor =  HextoUIColor.instance.hexString(hex: "#A954E4")
        self.layer.borderColor = borderColor.cgColor
    }

}
