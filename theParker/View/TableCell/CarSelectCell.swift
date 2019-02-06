//
//  CarSelectCell.swift
//  theParker
//
//  Created by Ketan Choyal on 07/01/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

class CarSelectCell: UITableViewCell {
    
    var carId : String?

    @IBOutlet weak var nameAndYear: UILabel!
    @IBOutlet weak var licenceNoAndColor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(car : Car) {
        nameAndYear.text = car.model + " " + "(" + car.year + " Model)"
        licenceNoAndColor.text = car.licence_plate + " (" + car.color + ")"
        carId = car.of
    }
    
    func setupView() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 2
        self.layer.borderWidth = 2
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        let borderColor: UIColor =  HextoUIColor.instance.hexString(hex: "#A954E4")
        self.layer.borderColor = borderColor.cgColor
    }

}
