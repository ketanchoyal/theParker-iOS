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

class MainPageVC: UIViewController , GMSMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
    
    var timer = Timer()
    var timerCount = Timer()
    var timershow = Timer()
    var markers:[GMSMarker] = []
    var pintimer = Timer()
    
    
    @IBOutlet var MainView: UIView!
    @IBOutlet weak var googleMaps: GMSMapView!
    @IBOutlet weak var menu: UIBarButtonItem!
    
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
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        DataService.instance.getMyCars { (success) in
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("I AM A CODER")
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
        
        showGlobalPins()
        
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
        
        let markerData = marker.userData as? LocationPin
        DataService.instance.selectedPin = markerData!
//        let endLoc = CLLocation(latitude: (markerData?.pinloc[0])!, longitude: (markerData?.pinloc[1])!)
//        self.drawPath(startLocation: CurLocationNow!, endLocation: endLoc)
//        print(markerData!.numberofspot)
        
        let bookThisSpotVC = self.storyboard?.instantiateViewController(withIdentifier: "bookThisSpotVC") as? BookThisSpotVC
        bookThisSpotVC?.initData()
        present(bookThisSpotVC!, animated: true, completion: nil)
//        presentDetail(bookThisSpotVC!)
        
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
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(DirectionKey)"
        
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
extension MainPageVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        // Change map location
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0)
        
        
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

extension MainPageVC {

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
    
    func showGlobalPins(){
        DataService.instance.getGlobalLocationPins { (success) in
            if success {
                self.IamshowingPins()
            } else {
                self.alert(message: "No Parking Spaces Available")
            }
        }
    }
    
    func IamshowingPins(){
        timershow = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.thanshow), userInfo: nil, repeats: true)
    }
    
    @objc func thanshow(){

            timershow.invalidate()
            showmarkers()
    }
    
    func showmarkers(){
        for (_, marker) in DataService.instance.markers {
            marker.map = googleMaps
        }
    }
}
