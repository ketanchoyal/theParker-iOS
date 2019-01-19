import UIKit

class OfferParkingVC: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    var floatingButton : ActionButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpFloatingButton()
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        // Do any additional setup after loading the view.
    }

}

extension OfferParkingVC{
    
    func goToPinLocation() {
        performSegue(withIdentifier: "pinLocation", sender: nil)
    }
    
    func setUpFloatingButton() {
        
        floatingButton = ActionButton(attachedToView: self.view, items: nil, buttonHeight: 50)
        floatingButton.setTitle("Offer Parking", fontsize: 20, forState: UIControl.State())
        floatingButton.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.3294117647, blue: 0.8941176471, alpha: 1)
        floatingButton.fontColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forState: UIControl.State())
        
        floatingButton.action = {editButtonItem in self.goToPinLocation()}
        //floatingButton.buttonTappedForSegue("addVehicleVC", self)
    }
}
