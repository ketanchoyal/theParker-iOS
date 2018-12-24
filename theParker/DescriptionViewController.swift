//
//  DescriptionViewController.swift
//  Parker
//
//  Created by Rahul Dhiman on 18/03/18.
//  Copyright © 2018 Rahul Dhiman. All rights reserved.
//

import UIKit
import EZYGradientView

class DescriptionViewController: UIViewController, UIScrollViewDelegate {
    
    
    let page1 = ["MainHeading":"Find Car parking near you","CenterImage":"way.png","explain":"Just search in the maps where you want your car parking."]
    let page2 = ["MainHeading":"Give your parking for credits","CenterImage":"parking(1).png","explain":"Share your location for users to see your parking location."]
    let page3 = ["MainHeading":"User Friendly App","CenterImage":"userF.png","explain":"select location and we will direct you there."]
    let page4 = ["MainHeading":"Your Car is in good hands","CenterImage":"shaky.png","explain":"We park your car in one of our secure areas."]
    
    var pageArray = [Dictionary<String,String>]()

    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var PageController: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ScrollView.delegate = self
        self.ScrollView.isPagingEnabled = true
        self.scrolling()
        self.addgrad()
        
       // self.ScrollView.backgroundColor = .red
        if DeviceType.IS_IPHONE_6P{
            
           // self.viewT.constant = 10
         //   self.viewL.constant = -10
        }

        // Do any additional setup after loading the view.
    }
}

extension DescriptionViewController{
    func scrolling(){
        
        pageArray = [page1,page2,page3,page4]
        
        
        if DeviceType.IS_IPHONE_6{
        
            self.ScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(pageArray.count),height: self.ScrollView.bounds.height-100)

        }
        
        else if DeviceType.IS_IPHONE_5{
            self.ScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(pageArray.count),height: self.ScrollView.bounds.height-150)
        }
        else{
            self.ScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(pageArray.count),height: self.ScrollView.bounds.height)}
        
        self.ScrollView.showsHorizontalScrollIndicator = false
        self.ScrollView.showsVerticalScrollIndicator = false
        
        self.loadScroll()
    }
    
    func loadScroll(){
        
        for (index, page) in pageArray.enumerated() {
            if let pageView = Bundle.main.loadNibNamed("Front", owner: self, options: nil)?.first as? Front
            {
               
                pageView.backgroundColor = .clear
                pageView.MainHeading.text = page["MainHeading"]
                pageView.Description.text = page["explain"]
                pageView.ImageVIew.image = UIImage(named: page["CenterImage"]!)
                pageView.Description.backgroundColor = .clear
                
                self.ScrollView.addSubview(pageView)
                pageView.frame.size.width = self.view.bounds.size.width
                
                if DeviceType.IS_IPHONE_5{
                pageView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width + 25
                }
                else if DeviceType.IS_IPHONE_6P{
                    pageView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width - 20
                }
                
                else{
                    pageView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
                }
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        self.PageController.currentPage = Int(page)
    }
}

extension DescriptionViewController{
    func addgrad(){
        let gradientView = EZYGradientView()
        gradientView.frame = self.view.bounds
        gradientView.firstColor = self.hexStringToUIColor(hex: "#000000")
        gradientView.secondColor = self.hexStringToUIColor(hex: "#4B0082")
        gradientView.angleº = 180.0
        gradientView.colorRatio = 0.4
        gradientView.fadeIntensity = 1.0
        gradientView.isBlur = true
        gradientView.blurOpacity = 0.5
        //self.GradientView.roundCorners(corners: [.bottomLeft], radius: 50)
        
        self.view.insertSubview(gradientView, at: 0)
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
}

extension DescriptionViewController{
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
}
