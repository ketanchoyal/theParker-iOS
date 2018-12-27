//
//  AdditionalDetailsVC.swift
//  theParker
//
//  Created by Ketan Choyal on 27/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class AdditionalDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = HextoUIColor.instance.hexString(hex: "#4C177D")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 50)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Additional Details"
    }

}
