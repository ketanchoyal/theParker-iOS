//
//  ParkingBookedVC.swift
//  theParker
//
//  Created by Ketan Choyal on 27/01/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire
import Lottie

class ParkingBookedVC: UIViewController {

    @IBOutlet weak var amountPaidLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mobileNoLabel: UILabel!
    @IBOutlet weak var lottie_Tick_Animation: UIView!
    
    @IBOutlet weak var directionMapView: GMSMapView!
    
    var amountPaid : String = ""
    
    var floatingGoogleMapOpenButton : ActionButton!
    var floatingHomeButton : ActionButton!
    
    var CurLocationNow:CLLocation?
    var locationManager = CLLocationManager()
    
    var timer = Timer()
    var timershow = Timer()
    var timerAnimation = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpfloatingHomeButton()
        setUpfloatingGoogleMapOpenButton()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        setupData()
        
        directionMapView.delegate = self
        directionMapView.isMyLocationEnabled = true
        directionMapView.settings.zoomGestures = true
        scheduledTimerForCurrentLoc()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.animationTimer()
        })
        
        IamshowingPins()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.viewDidDisappear(animated)
        timerAnimation.invalidate()
        timer.invalidate()
        timershow.invalidate()
    }
    
    func initData(amountPaid : String){
        self.amountPaid = amountPaid
    }
    
    func setupData() {
        amountPaidLabel.text = "\(amountPaid)"
        
        let marker = DataService.instance.selectedPin
        
        addressLabel.text = marker.address
        mobileNoLabel.text = marker.mobile
        
        let endLoc = CLLocation(latitude: (marker.pinloc[0]), longitude: (marker.pinloc[1]))
        //drawPath(startLocation: CurLocationNow!, endLocation: endLoc)
        
        floatingGoogleMapOpenButton.action = {editButtonItem in self.Direction(startLocation: self.CurLocationNow!, endLocation: endLoc, handler: { (success) in
            if !success {
                self.alert(message: "Install Google Maps first!")
            }
        })}
    }
    
    @IBAction func copyButtonTapped(_ sender: Any) {
        UIPasteboard.general.string = addressLabel.text
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        callNumber(phoneNumber: mobileNoLabel.text!)
    }
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    
    func setUpfloatingGoogleMapOpenButton() {
        floatingGoogleMapOpenButton = ActionButton(attachedToView: self.view, items: nil, buttonHeight: 50, buttonWidth: 150, buttonType: .Rectangle, position: .BottomRight)
        floatingGoogleMapOpenButton.setTitle("Show in Map", fontsize: 18, forState: UIControl.State())
        floatingGoogleMapOpenButton.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.3294117647, blue: 0.8941176471, alpha: 1)
        floatingGoogleMapOpenButton.fontColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forState: UIControl.State())
    }
    
    func setUpfloatingHomeButton() {
        floatingHomeButton = ActionButton(attachedToView: self.view, items: nil, buttonHeight: 50, buttonWidth: 100, buttonType: .Rectangle, position: .BottomLeft)
        floatingHomeButton.setTitle(" Done ", fontsize: 18, forState: UIControl.State())
        floatingHomeButton.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.3294117647, blue: 0.8941176471, alpha: 1)
        floatingHomeButton.fontColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forState: UIControl.State())
        floatingHomeButton.action = { item in self.gotoHomeVC()}
    }
    
    func gotoHomeVC() {
        performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }
    
    func alert(message:String )
    {
        let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertview.addAction(UIAlertAction(title: "Okay!", style: .default, handler: {
            action in
            DispatchQueue.main.async { }
        }))
        self.present(alertview, animated: true, completion: nil)
    }
    
}

extension ParkingBookedVC : GMSMapViewDelegate, CLLocationManagerDelegate {
    //MARK: - Location Manager delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        self.CurLocationNow = location
        self.locationManager.stopUpdatingLocation()
        
    }
    
    // MARK: - GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        directionMapView.isMyLocationEnabled = true
        directionMapView.settings.myLocationButton = false
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        directionMapView.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        directionMapView.isMyLocationEnabled = true
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        directionMapView.isMyLocationEnabled = true
        directionMapView.selectedMarker = nil
        return false
    }
    
}

extension ParkingBookedVC {
    // Scheduling timer to show current Location
    func scheduledTimerForCurrentLoc(){
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.gotoMyLocation), userInfo: nil, repeats: true)
    }
    
    @objc func gotoMyLocation(){
        
        if self.CurLocationNow?.coordinate.latitude != nil && self.CurLocationNow?.coordinate.longitude != nil {
            
            let camera2 = GMSCameraPosition.camera(withLatitude: (self.CurLocationNow?.coordinate.latitude)!, longitude: (self.CurLocationNow?.coordinate.longitude)!, zoom: 16.0)
            
            self.directionMapView.camera = camera2
            self.directionMapView.delegate = self
            self.directionMapView?.isMyLocationEnabled = true
            self.directionMapView.settings.myLocationButton = false
            self.directionMapView.settings.compassButton = true
            self.directionMapView.settings.zoomGestures = true
            self.stopTimer()
            
        }
    }
    
    func stopTimer(){
        timer.invalidate()
        
    }
    
    //Show Current ParkingSpot
    func IamshowingPins(){
        timershow = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.thanshow), userInfo: nil, repeats: true)
    }
    
    @objc func thanshow(){
        
        timershow.invalidate()
        showmarkers()
    }
    
    func showmarkers(){
        let pinLoc = DataService.instance.selectedPin.pinloc
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(pinLoc[0], pinLoc[1])
        marker.map = directionMapView
        
        let endLoc = CLLocation(latitude: pinLoc[0], longitude: pinLoc[1])
        drawPath(startLocation: CurLocationNow!, endLocation: endLoc, directionMapView: directionMapView)
    }
    
}

extension ParkingBookedVC {
    
    func animationTimer() {
        timerAnimation = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.animationLOT), userInfo: nil, repeats: true)
    }
    
    @objc func animationLOT() {
        let successAmination = LOTAnimationView(name: "success")
        
        self.lotanime(successAmination, lottie_Tick_Animation)
    }
    
    func lotanime(_ animations:LOTAnimationView,_ vview:UIView){
        animations.frame = CGRect(x: 0, y: -30, width: vview.frame.width, height: vview.frame.height * 2.5)
        animations.contentMode = .scaleAspectFit
        vview.addSubview(animations)
        animations.play()
    }
}
