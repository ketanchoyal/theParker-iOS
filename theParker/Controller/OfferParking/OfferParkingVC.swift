import UIKit

class OfferParkingVC: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    var floatingButton : ActionButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpFloatingButton()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
        
        floatingButton = ActionButton(attachedToView: self.view, items: nil)
        floatingButton.setImage(UIImage(named: "plus"), forState: UIControl.State())
        floatingButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        floatingButton.action = {editButtonItem in self.goToPinLocation()}
        //floatingButton.buttonTappedForSegue("addVehicleVC", self)
    }
}
