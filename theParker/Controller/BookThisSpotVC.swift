//
//  BookThisSpotVC.swift
//  theParker
//
//  Created by Ketan Choyal on 29/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class BookThisSpotVC: UIViewController {
    
    public private(set) var markerData : LocationPin?
    
    @IBOutlet weak var hostImage: CircleImage!
    @IBOutlet weak var hostName: UILabel!
    @IBOutlet weak var parkingType: UILabel!
    @IBOutlet weak var parkingPricePerHour: RoundedLabel!
    @IBOutlet weak var parkingDescription: UILabel!
    @IBOutlet weak var parkingInstruction: UILabel!
    @IBOutlet weak var featuresView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var noAdditionalFeatureLabel: UILabel!
    @IBOutlet weak var featureHeadingLabel: UILabel!
    @IBOutlet weak var feature1Label: UILabel!
    @IBOutlet weak var feature2Label: UILabel!
    @IBOutlet weak var feature3Label: UILabel!
    @IBOutlet weak var feature4Label: UILabel!
    
    @IBOutlet weak var detailButtonView: UIView!
    @IBOutlet weak var detailBtnLabel: UILabel!
    
    @IBOutlet weak var featureButtonView: UIView!
    @IBOutlet weak var featureBtnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(markerData?.features)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpData()
    }
    
    func initData(forMarker markerData : LocationPin) {
        self.markerData = markerData
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bookSpotTapped(_ sender: Any) {
        performSegue(withIdentifier: "carSelectSegue", sender: markerData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let carSelectVC = segue.destination as? CarSelectVC
        carSelectVC?.initData(forMarker: (sender as? LocationPin)!)
    }
    
}

extension BookThisSpotVC {
    
    @IBAction func detailBtnTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3) {
            self.featureButtonView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.detailButtonView.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.3294117647, blue: 0.8941176471, alpha: 1)
            
            self.featureBtnLabel.textColor = #colorLiteral(red: 0.662745098, green: 0.3294117647, blue: 0.8941176471, alpha: 1)
            self.detailBtnLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            self.detailsView.isHidden = false
            self.featuresView.isHidden = true
        }
    }
    
    @IBAction func featureBtnTapped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3) {
            self.featureButtonView.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.3294117647, blue: 0.8941176471, alpha: 1)
            self.detailButtonView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            self.featureBtnLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.detailBtnLabel.textColor = #colorLiteral(red: 0.662745098, green: 0.3294117647, blue: 0.8941176471, alpha: 1)
            
            
            self.detailsView.isHidden = true
            self.featuresView.isHidden = false
        }
    }
    
    func setUpData() {
        hostName.text = markerData?.by
        parkingType.text = markerData?.type
        let price = markerData?.price_hourly
        parkingPricePerHour.text = "₹" + price! + "/hr"
        parkingDescription.text = markerData?.description
        parkingInstruction.text = markerData?.instructions
        
        setFeatures()
    }
    
    func setFeatures() {
        let featureCount = markerData?.features.count
        noFeatures()
        noAdditionalFeatureLabel.isHidden = true
        if featureCount == 0 {
            self.noFeatures()
        } else if featureCount == 1 {
            if self.markerData?.features[0] == "No Features" {
                self.noFeatures()
            } else {
                self.featureHeadingLabel.isHidden = false
                self.feature1Label.text = self.markerData?.features[0]
                self.feature1Label.isHidden = false
            }
        } else if featureCount == 2 {
            self.featureHeadingLabel.isHidden = false
            self.feature1Label.text = self.markerData?.features[0]
            self.feature1Label.isHidden = false
            
            self.feature2Label.text = self.markerData?.features[1]
            self.feature2Label.isHidden = false
        } else if featureCount == 3 {
            self.featureHeadingLabel.isHidden = false
            self.feature1Label.text = self.markerData?.features[0]
            self.feature1Label.isHidden = false
            
            self.feature2Label.text = self.markerData?.features[1]
            self.feature2Label.isHidden = false
            
            self.feature3Label.text = self.markerData?.features[2]
            self.feature3Label.isHidden = false
        } else if featureCount == 4 {
            self.featureHeadingLabel.isHidden = false
            self.feature1Label.text = self.markerData?.features[0]
            self.feature1Label.isHidden = false
            
            self.feature2Label.text = self.markerData?.features[1]
            self.feature2Label.isHidden = false
            
            self.feature3Label.text = self.markerData?.features[2]
            self.feature3Label.isHidden = false
            
            self.feature4Label.text = self.markerData?.features[3]
            self.feature4Label.isHidden = false
        }
    }
    
    func noFeatures() {
        noAdditionalFeatureLabel.isHidden = false
        
        featureHeadingLabel.isHidden = true
        feature1Label.isHidden = true
        feature2Label.isHidden = true
        feature3Label.isHidden = true
        feature4Label.isHidden = true
    }
}
