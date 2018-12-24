//
//  MainPageViewController.swift
//  Parker
//
//  Created by Rahul Dhiman on 06/03/18.
//  Copyright © 2018 Rahul Dhiman. All rights reserved.
//

import UIKit
import Firebase
import EZYGradientView
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

enum Located {
    case startLocation
    case destinationLocation
}

class MainPageViewController: UIViewController , GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{

    var timer = Timer()
    var timerCount = Timer()
    var timershow = Timer()
    var markers:[GMSMarker] = []
    var pintimer = Timer()
   
   
    
    
    
    @IBOutlet weak var HeightGoogleMapsCONST: NSLayoutConstraint!
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var googleMaps: GMSMapView!
    @IBOutlet weak var menu: UIBarButtonItem!
    
    
   
    
    @IBOutlet weak var BookingStack: UIStackView!
    @IBOutlet weak var CarName: UILabel!
    @IBOutlet weak var TimeInfo: UILabel!
    @IBOutlet weak var PriceInfo: UILabel!
    @IBOutlet weak var LocationInfo: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var BookButton: UIButton!
    
    @IBAction func bookingbtnclicked(_ sender: Any) {
        
        
        
    }
    
    
    
    var CurLocationNow:CLLocation?
    var locationManager = CLLocationManager()
    var locationSelected = Located.startLocation
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    var HandlePins:DatabaseHandle?
    var handleG:DatabaseHandle?
    var ref:DatabaseReference?
    var pins:[String:Any]?
    var countG:Int?
    var showpins:[[Int:[String:Any]]] = []

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = self.hexStringToUIColor(hex: "#4C177D")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let attributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Bold", size: 50)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.title = "PARKER"
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.BookButton.layer.cornerRadius = 10
        self.BookingStack.isHidden = true
        self.ScrollHandling()
        self.fetchTimer()
        print("I AMMMMMMMM INNININININ IMMAIMAIMAIAM")
        // Do any additional setup after loading the view.
        
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startMonitoringSignificantLocationChanges()
        
            menu.target = revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
        
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        let camera = GMSCameraPosition.camera(withLatitude: -7.9293122, longitude: 112.5879156, zoom: 15.0)
        
        self.googleMaps.camera = camera
        self.googleMaps.delegate = self
        self.googleMaps?.isMyLocationEnabled = true
        self.googleMaps.settings.myLocationButton = true
        self.googleMaps.settings.compassButton = true
        self.googleMaps.settings.zoomGestures = true
        
        self.setforSE()
        
        self.scheduledTimerWithTimeInterval()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2DMake(latitude, longitude)
    marker.title = titleMarker
    marker.icon = iconMarker
    marker.map = googleMaps
}

//MARK: - Location Manager delegates

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
    googleMaps.isMyLocationEnabled = true
}

func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    googleMaps.isMyLocationEnabled = true
    
    if (gesture) {
        mapView.selectedMarker = nil
    }
}

func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    googleMaps.isMyLocationEnabled = true
    print("TAPPED TAPPED")
    
    let DataNeeded:[String] = marker.userData as! [String]
    self.CarName.text = DataNeeded[2]
    self.LocationInfo.text = DataNeeded[0]
    self.Description.text = DataNeeded[5]
    self.TimeInfo.text = marker.title
    self.PriceInfo.text = marker.snippet
    self.BookingStack.isHidden = false
    return false
}

func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    print("COORDINATE \(coordinate)") // when you tapped coordinate
}

func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
    googleMaps.isMyLocationEnabled = true
    googleMaps.selectedMarker = nil
    return false
}



//MARK: - this is function for create direction path, from start location to desination location

func drawPath(startLocation: CLLocation, endLocation: CLLocation)
{
    let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
    let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
    
    
    let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
    
    Alamofire.request(url).responseJSON { response in
        
        do {
            let json = try JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.blue
                polyline.map = self.googleMaps
            }
        } catch {
            print(error)
        }
    }
}

func Direction(startLocation: CLLocation, endLocation: CLLocation) {
    let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
    let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
    
    if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
        UIApplication.shared.openURL(URL(string:
            "comgooglemaps://?saddr=\(origin)&daddr=\(destination)&center=37.423725,-122.0877&directionsmode=driving&zoom=17")!)
         
    } else {
        self.alert(message: "Install Google Maps first!")
    }
    
    
}



func touchSearchBar()     {
    let autoCompleteController = GMSAutocompleteViewController()
    autoCompleteController.delegate = self
    
    // selected location
    locationSelected = .startLocation
    
    // Change text color
    self.locationManager.stopUpdatingLocation()
    
    self.present(autoCompleteController, animated: true, completion: nil)
    
}

@IBAction func searchGoogleMaps(_ sender: Any) {
    
    
    self.touchSearchBar()
    
}

func textFieldDidBeginEditing(_ textField: UITextField) {
    touchSearchBar()
}

// MARK: SHOW DIRECTION WITH BUTTON
@IBAction func SetView(_ sender: Any) {
    self.Direction(startLocation: self.CurLocationNow!, endLocation: locationStart)
}

}




// MARK: - GMS Auto Complete Delegate, for autocomplete search location
extension MainPageViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Change map location
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0
        )
        
        
        locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
       // createMarker(titleMarker: "Location Start", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        
        
        
        if locationStart.coordinate.longitude != 0.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.googleMaps.animate(toZoom: 16.0)
            })
        }
        
        
        
        
        
        
        self.googleMaps.camera = camera
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

extension MainPageViewController {
    
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
    
    
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.chartload), userInfo: nil, repeats: true)
    }
    
    @objc func chartload(){
        
        if self.CurLocationNow?.coordinate.latitude != nil && self.CurLocationNow?.coordinate.longitude != nil {
            
            let camera2 = GMSCameraPosition.camera(withLatitude: (self.CurLocationNow?.coordinate.latitude)!, longitude: (self.CurLocationNow?.coordinate.longitude)!, zoom: 15.0)
            
            self.googleMaps.camera = camera2
            self.googleMaps.delegate = self
            self.googleMaps?.isMyLocationEnabled = true
            self.googleMaps.settings.myLocationButton = true
            self.googleMaps.settings.compassButton = true
            self.googleMaps.settings.zoomGestures = true
            self.stopTimer()
            
        }
    }
    
    func stopTimer(){
        timer.invalidate()
        
    }
    
    func setforSE(){
        if DeviceType.IS_IPHONE_5 {
            self.HeightGoogleMapsCONST.constant -= 100
        }
        if DeviceType.IS_IPHONE_6{
            self.HeightGoogleMapsCONST.constant -= 50
        }
    }
    
    func handlingGlobalPins(){
        print("GGGG here")
        if self.countG! > 1 {
        for c in 1...self.countG! {
            self.ref = Database.database().reference()
            
            HandlePins = self.ref?.child("GlobalPins").child("\(c)").observe(.value, with: { (snapshot) in
                print("Printing C")
                print(c)
                if let value1 = snapshot.value as? [String:Any]{
                    let valueactual = [c:value1]
               // print(valueactual)
                    self.showpins.append(valueactual)
                    //print(valueactual)
                   // print(self.showpins)
                }
                
                if c == self.countG!{
                    self.IamshowingPins()
                }
                
            })
        }
        }
    }
    
    func ScrollHandling(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.ref = Database.database().reference()
        
        handleG = self.ref?.child("count").child("g").observe(.value, with: { (snapshot) in
            
            if let value1 = snapshot.value as? Int{
                
                self.countG = Int(value1)
            }
            
        })
    }
    
    func fetchTimer(){
        timerCount = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.selectFun), userInfo: nil, repeats: true)
    }
    
    @objc func selectFun(){
        if self.countG != nil {
            self.handlingGlobalPins()
            timerCount.invalidate()
        }
    }
    
    func IamshowingPins(){
        timershow = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.thanshow), userInfo: nil, repeats: true)
    }
    
    @objc func thanshow(){
        if !self.showpins.isEmpty{
            
         
            
            print("Showing Pins")
            for c in 0...self.showpins.count{
                 var neededata:[String] = []
                let marker = GMSMarker()
                if c < self.showpins.count {
                for (key,value) in self.showpins[c]{
                    for (key2,val) in value {
                        var count = 0
                        
                        var latt:Double = 0.0
                        var long:Double = 0.0
                        
                        if key2 == "pinloc"{
                            let dicval = val as! [String:Double]
                            for (keyy,vall) in dicval {
                                if keyy == "lat"{
                                    latt = vall
                                }
                                if keyy == "long"{
                                    long = vall
                                }
                                marker.position = CLLocationCoordinate2DMake(latt, long)
                                print(marker.position)
                            }
                        }
                        
                        if key2 == "Time"{
                            let time = val as! String
                            marker.title = "\(time)"
                            print(marker.title!)
                            count += 1
                        }
                        if key2 == "Price"{
                            let snip = val as! String
                            marker.snippet = "\(snip)"
                            print(marker.snippet!)
                            count += 1
                            print("DONE DONE DONE")
                            print(marker)
                            
                            marker.appearAnimation = .pop
                        }
                        
                        if key2 == "Car"{
                            
                           neededata.append(val as! String)
                        }
                        
                        if key2 == "Location"{
                            neededata.append(val as! String)
                        }
                        
                        if key2 == "Description"{
                            neededata.append(val as! String)
                        }
                        
                        if key2 == "Day"{
                            let rollNumber:String = String(format: "%@", val as! CVarArg)
                            neededata.append(rollNumber)
                        }
                        
                        if key2 == "Month"{
                            let rollNumber:String = String(format: "%@", val as! CVarArg)
                            neededata.append(rollNumber)
                        }
                        
                        if key2 == "Year" {
                            print(val)
                            let rollNumber:String = String(format: "%@", val as! CVarArg)
                            neededata.append(rollNumber)
                        }
                        print("countbro")
                        
                    }
                    
                }
                
            }
                marker.userData = neededata
                self.markers.append(marker)
            }
            timershow.invalidate()
            
            self.showmarkers()
        }
    }
    
    func showmarkers(){
        for c in 0...self.markers.count-1{
            print(markers[c])
           
            //self.markers[c].map = googleMaps
            
            
        }
        self.ppintimer()
    }
    
    func ppintimer(){
       pintimer =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.pintimedone), userInfo: nil, repeats: true)
    }
    
   @objc func pintimedone(){
    
        let mdate = Date()
        let mcalendar = Calendar.current
        let day = mcalendar.component(.day, from: mdate)
        let month = mcalendar.component(.month, from: mdate)
        let year = mcalendar.component(.year, from: mdate)
        var hour = mcalendar.component(.hour, from: mdate)
        let minutes = mcalendar.component(.minute, from: mdate)
    
        for c in 0...self.markers.count-2{
            
            if hour > 12 {
                hour = hour - 12
            }
            
            let stringArray = markers[c].title?.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let DataNeeded:[String] = markers[c].userData as! [String]
            
            if Int(DataNeeded[1])! < year {
               
                markers[c].map = nil
            }
                
            else if Int(DataNeeded[3])! < month {
                
               markers[c].map = nil
            }
                
            else if Int(DataNeeded[4])! < day {
               
               markers[c].map = nil
            }
                
            else if Int(stringArray![0])! < hour {
                
               markers[c].map = nil
            }
                
            else if Int(stringArray![1])! < minutes {
                
               markers[c].map = nil
            }
            
            else {
                markers[c].map = self.googleMaps
            }
            
            
        }
    }
    
}

