//
//  E-WalletVC.swift
//  theParker
//
//  Created by Ketan Choyal on 26/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit
import Lottie

class E_WalletVC: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var leftBarBtnView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuBtn(_ sender: Any) {
        //perform Animation
//        animationsLOT() //Not working
    }
    
    
//    func animationsLOT(){
//        let Tanimations = LOTAnimationView(name: "HamburgerArrow")
//        
//        self.lotanime(Tanimations, self.leftBarBtnView)
//
//    }
//
//    func lotanime(_ animations:LOTAnimationView,_ vview:UIView){
//        animations.frame = CGRect(x: 0, y: 0, width: vview.frame.width, height: vview.frame.height)
//        animations.contentMode = .scaleAspectFit
//        animations.center = vview.center
//        vview.addSubview(animations)
//        animations.loopAnimation = false
//        animations.play()
//
//    }
   
}
