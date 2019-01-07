//
//  CarSelectVC.swift
//  theParker
//
//  Created by Ketan Choyal on 07/01/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

class CarSelectVC: UIViewController {
    
    public private(set) var markerData : LocationPin?

    @IBOutlet weak var carsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(markerData?.pinloc as Any)
        
        carsTable.delegate = self
        carsTable.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataService.instance.getMyCars { (success) in
            if success {
                self.carsTable.reloadData()
            }
        }
        
    }
    
    func initData(forMarker markerData : LocationPin) {
        self.markerData = markerData
    }
    @IBAction func addCarTapped(_ sender: Any) {
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CarSelectVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.myCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "carSelectCell") as? CarSelectCell else { return UITableViewCell() }
        
        let cars = DataService.instance.myCars
        let key = Array(cars.keys)[indexPath.row]
        let car = cars[key]
        
        cell.configureCell(car: car!)
        
        return cell
    }
    
    
}
