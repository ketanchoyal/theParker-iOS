//
//  UIViewControllerExt.swift
//  Breakpoint
//
//  Created by Ketan Choyal on 19/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent : UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
    
    //MARK: - this is function will open GoogleMap if installed
    func Direction(startLocation: CLLocation, endLocation: CLLocation, handler : @escaping (_ completionHandler : Bool) -> ()) {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?saddr=\(origin)&daddr=\(destination)&center=37.423725,-122.0877&directionsmode=driving&zoom=17")!)
            handler(true)
        } else {
            handler(false)
        }
    }
    
    //MARK: - this is function for create direction path, from start location to desination location
    func drawPath(startLocation: CLLocation, endLocation: CLLocation, directionMapView : GMSMapView)
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
                    polyline.map = directionMapView
                }
            } catch {
                print(error)
            }
        }
    }

    
}
