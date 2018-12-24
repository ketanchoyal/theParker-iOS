//
//  PostMapPinViewController.swift
//  Parker
//
//  Created by Rahul Dhiman on 20/03/18.
//  Copyright © 2018 Rahul Dhiman. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

class PostMapPinViewController: UIViewController, GMSMapViewDelegate , CLLocationManagerDelegate{
    
    var timer = Timer()
    var timer1 = Timer()
    var HandleLocation:DatabaseHandle?
    var ref:DatabaseReference?
    var count = 0
    var FetchedArray:Int? = 0
    var flag = 0
    
    @IBOutlet weak var TopLabel: UILabel!
    @IBOutlet weak var MapView: GMSMapView!
    @IBOutlet weak var nextBTn: UIButton!
    @IBOutlet weak var btnView: UIView!
    
    var CurLocationNow:CLLocation?
    var locationManager = CLLocationManager()
    var locationSelected = Located.startLocation
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    var arrayCoordinates : CLLocationCoordinate2D?
    var longPressRecognizer = UILongPressGestureRecognizer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = self.hexStringToUIColor(hex: "#4C177D")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 50)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "PinLocation"
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.handling()
        self.nextBTn.layer.cornerRadius = 20
        self.nextBTn.clipsToBounds = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                           action: #selector(self.longPress))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delegate = self
        MapView.addGestureRecognizer(longPressRecognizer)
        
        MapView.isMyLocationEnabled = true
        MapView.settings.compassButton = true
        btnView.backgroundColor = .clear
        
        self.scheduledTimerWithTimeInterval()
    }
    
    @IBAction func NextButtonClicked(_ sender: Any) {
    
        if count > 0 {
            print(" BUTTO PREESSSESS HERE")
            self.LoadIt()
            self.nextBTn.isEnabled = false
        }
        
    }
 
}

extension PostMapPinViewController{
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.chartload), userInfo: nil, repeats: true)
    }
    
    @objc func chartload(){
        
        if self.CurLocationNow?.coordinate.latitude != nil && self.CurLocationNow?.coordinate.longitude != nil {
            
            let camera2 = GMSCameraPosition.camera(withLatitude: (self.CurLocationNow?.coordinate.latitude)!, longitude: (self.CurLocationNow?.coordinate.longitude)!, zoom: 18.0)
            
            self.MapView.camera = camera2
            self.MapView.delegate = self
            self.MapView.isMyLocationEnabled = true
            self.MapView.settings.myLocationButton = true
            self.MapView.settings.compassButton = true
            self.MapView.settings.zoomGestures = true
            self.stopTimer()
            
        }
    }
    
    func stopTimer(){
        timer.invalidate()
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    }
    
    func alert(message:String )
    {
        
        
        
        let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertview.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: {
            action in
            DispatchQueue.main.async {
                
                //  self.UISetup(enable: true)
            }
        }))
        self.present(alertview, animated: true, completion: nil)
        
    }
}

extension PostMapPinViewController{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        self.CurLocationNow = location
        //        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        //        self.googleMaps?.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    // MARK: - GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        MapView.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        MapView.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        MapView.isMyLocationEnabled = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        MapView.isMyLocationEnabled = true
        MapView.selectedMarker = nil
        return false
    }
    
   
}

extension PostMapPinViewController : UIGestureRecognizerDelegate
{
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        let newMarker = GMSMarker(position: MapView.projection.coordinate(for: sender.location(in: MapView)))
        self.MapView.clear()
        self.arrayCoordinates = newMarker.position
        newMarker.map = MapView
        self.count += 1
        print(self.arrayCoordinates)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}


extension PostMapPinViewController{
    
    func appendArray(completion: @escaping ((_ success:Bool)->())){
        
        let pushedLoc = String(describing: self.arrayCoordinates!)
        let lat:Double = (self.arrayCoordinates?.latitude)!
        let lon:Double = (self.arrayCoordinates?.longitude)!
        let latlongarrat:[Double] = [lat,lon]
        self.performSegue(withIdentifier: "sspin", sender: latlongarrat)
       print("PUSHED LOC HERE")
        print(pushedLoc)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sg = segue.destination as! ScrollPostViewController
        sg.latlongstring = sender as! [Double]
    }
}

extension PostMapPinViewController{
    func handling(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.ref = Database.database().reference()
        //Going deep into firebase hierarchy
        self.HandleLocation = self.ref?.child("user").child(uid).child("ArrayPins").observe(.value, with: { (snapshot) in
            
            if let value = snapshot.childrenCount as? UInt{
                
                print("VALUE VALUE")
                print(value)
                let vvalue = Int(value)
                self.FetchedArray = vvalue
                
            }
        })
    }
}

extension PostMapPinViewController{
    
    
    func LoadIt(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer1 = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.chartload1), userInfo: nil, repeats: true)
    }
    
    @objc func chartload1(){
        
        if self.FetchedArray == 0 {
            
        }
        else{
            self.stopTimer1()
            self.appendArray(completion: { success in
                if success {
                    print("Yahoo Yahoo Yahooo")
                    
                }
                else{
                    print("NO NO NO")
                }
            })
        }
        
        }
    
    
    func stopTimer1(){
        timer1.invalidate()
        
    }
}

    


