//
//  AdditionalDetailsVC.swift
//  theParker
//
//  Created by Ketan Choyal on 27/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class AdditionalDetailsVC: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var instructionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        instructionTextView.delegate = self
        
        print("pin : \(DataService.pinToUpload)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }

    @IBAction func addPhotoButton(_ sender: Any) {
        //TODO : Upload photo function
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        
        nextButton.isEnabled = false
        addData { (success) in
            if success {
                self.performSegue(withIdentifier: "availabilityAndPrice", sender: nil)
                self.nextButton.isEnabled = true
            } else {
                self.nextButton.isEnabled = true
                self.alert(message: "something went wrong!")
            }
        }
        
    }
    
    func addData(completionHandler : @escaping (_ complete : Bool) -> ()) {
        let description = descriptionTextView.text
        let instruction = instructionTextView.text
        let pin = DataService.pinToUpload
        
        if (description != "Add brief description/selling points of your space. E.g. 5 min walk to bus stop") &&  !description!.isBlank {
            pin.description = description!
        }
        
        if (instruction != "Add any special instruction required. E.g. Do not block the sideway") && !instruction!.isBlank {
            pin.instructions = instruction!
        }
        completionHandler(true)
    }
    
    func alert(message:String )
    {
        let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertview.addAction(UIAlertAction(title: "Try Again", style: .default, handler: {
            action in
            DispatchQueue.main.async {
                //focus on the view
            }
        }))
        self.present(alertview, animated: true, completion: nil)
        
    }
    
}

extension AdditionalDetailsVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
