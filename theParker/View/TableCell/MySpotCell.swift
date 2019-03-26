//
//  MySpotCell.swift
//  theParker
//
//  Created by Ketan Choyal on 27/03/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit
import GoogleMaps

class MySpotCell: UITableViewCell, GMSMapViewDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        mapView.delegate = self
//        mapView?.isMyLocationEnabled = false
//        mapView.settings.compassButton = false
//        mapView.settings.zoomGestures = false
    }
    
    func configureCell(locationpin : LocationPin) {
        mapView.delegate = self
        mapView?.isMyLocationEnabled = false
        mapView.settings.compassButton = false
        mapView.settings.zoomGestures = false
        mapView.isUserInteractionEnabled = false
        visibilityLabel.text = locationpin.availability
        priceLabel.text = "₹\(locationpin.price_hourly)/Hr"
        typeLabel.text = locationpin.type
        
        let camera = GMSCameraPosition.camera(withLatitude: locationpin.pinloc[0], longitude: locationpin.pinloc[1], zoom: 15)
        self.mapView.camera = camera
        createMarker(titleMarker: nil, iconMarker: nil, latitude: locationpin.pinloc[0], longitude: locationpin.pinloc[1])
        
    }
    
    func createMarker(titleMarker: String?, iconMarker: UIImage?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
//        marker.title = titleMarker
        marker.icon = UIImage(named: "marker-image")
        marker.map = mapView
    }

}
