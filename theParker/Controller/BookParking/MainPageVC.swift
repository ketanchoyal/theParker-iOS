import UIKit
import Firebase
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
    
    var floatingSearchButton : ActionButton!
    var floatingLocationButton : ActionButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            UIApplication.shared.statusBarStyle = .default
        })
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.662745098, green: 0.3294117647, blue: 0.8941176471, alpha: 1), NSAttributedString.Key.strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), NSAttributedString.Key.backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1992722603)]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        DataService.instance.getMyCars { (_) in }
        DataService.instance.getMyPins { (_) in }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @IBAction func unwindToMainVC(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFloatingSearchButton()
        setUpFloatingLocationButton()
        
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
        
//        let camera = GMSCameraPosition.camera(withLatitude: -7.9293122, longitude: 112.5879156, zoom: 15.0)
//
//        self.googleMaps.camera = camera
        self.googleMaps.delegate = self
        self.googleMaps?.isMyLocationEnabled = true
        self.googleMaps.settings.compassButton = true
        self.googleMaps.settings.zoomGestures = true
        
        //gotoMyLocation()
        
        showGlobalPins()
        
        scheduledTimerForCurrentLoc()
        
    }
    
    func setUpFloatingSearchButton() {
        floatingSearchButton = ActionButton(attachedToView: self.view, items: nil, buttonHeight: 50, buttonWidth: 100, buttonType: .Rectangle, position: .BottomLeft)
        floatingSearchButton.setTitle(" Search ", fontsize: 18, forState: UIControl.State())
        floatingSearchButton.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.3294117647, blue: 0.8941176471, alpha: 1)
        floatingSearchButton.fontColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forState: UIControl.State())
        floatingSearchButton.show()
        
        floatingSearchButton.action = {editButtonItem in self.touchSearchBar()}
    }
    
    func setUpFloatingLocationButton() {
        floatingLocationButton = ActionButton(attachedToView: self.view, items: nil, buttonHeight: 50, buttonWidth: 50, buttonType: .Circle, position: .BottomRight)
        floatingLocationButton.setImage(UIImage(named: "myLocation"), forState: UIControl.State())
        floatingLocationButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        floatingLocationButton.border(color: #colorLiteral(red: 0.662745098, green: 0.3294117647, blue: 0.8941176471, alpha: 1), width: 2)
        floatingLocationButton.show()
        
        floatingLocationButton.action = {editButtonItem in self.gotoMyLocation()}
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
        googleMaps.settings.myLocationButton = false
        
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
    
    func touchSearchBar()     {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // selected location
        locationSelected = .startLocation
        
        // Change text color
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        touchSearchBar()
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
    // Scheduling timer to show current Location
    func scheduledTimerForCurrentLoc(){
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.gotoMyLocation), userInfo: nil, repeats: true)
    }
    
    @objc func gotoMyLocation(){
        
        if self.CurLocationNow?.coordinate.latitude != nil && self.CurLocationNow?.coordinate.longitude != nil {
            
            let camera2 = GMSCameraPosition.camera(withLatitude: (self.CurLocationNow?.coordinate.latitude)!, longitude: (self.CurLocationNow?.coordinate.longitude)!, zoom: 15.0)
            
            self.googleMaps.camera = camera2
            self.googleMaps.delegate = self
            self.googleMaps?.isMyLocationEnabled = true
            self.googleMaps.settings.myLocationButton = false
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
            if (marker.userData as? LocationPin)?.availability == "open"{
                marker.map = googleMaps
            }
            if (marker.userData as? LocationPin)?.availability == "closed" {
                marker.map = nil
                let key = (marker.userData as? LocationPin)?.pinKey
                DataService.instance.markers.removeValue(forKey: key!)
            }
        }
    }
}
