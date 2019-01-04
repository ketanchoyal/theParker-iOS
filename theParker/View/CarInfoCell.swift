//
//  VehicleInfoCell.swift
//  theParker
//
//  Created by Ketan Choyal on 30/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

@IBDesignable
class CarInfoCell: UITableViewCell {

    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var licence_plate_Number: UILabel!
    
    var carId : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(car : Car) {
        model.text = car.model
        year.text = car.year
        color.text = car.color
        licence_plate_Number.text = car.licence_plate
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

    @IBAction func deleteCarTapped(_ sender: Any) {
        //alert(message: "Are you sure, you want to delete this Car?")
        DataService.instance.deleteCar(ofId: self.carId!, handler: { (success) in
            if success {
                DataService.instance.getMyCars(handler: { (success) in
                    
                })
            }
        })
    }
    
    func alert(message:String )
    {
        let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertview.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
            action in
            DataService.instance.deleteCar(ofId: self.carId!, handler: { (success) in
                if success {
                    DataService.instance.getMyCars(handler: { (success) in
                        
                    })
                }
            })

        }))
        alertview.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            action in
            DispatchQueue.main.async {
                
                //  self.UISetup(enable: true)
            }
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertview, animated: true, completion: nil)
        
    }
    
}
