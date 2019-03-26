import UIKit

class OfferParkingVC: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    var floatingButton : ActionButton!
    
    @IBOutlet weak var mySpotsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySpotsTableView.delegate = self
        mySpotsTableView.dataSource = self
        
        setUpFloatingButton()
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        DataService.instance.getMyPins { (success) in
            //Refresh table
            self.mySpotsTableView.reloadData()
        }

    }
    
    func goToPinLocation() {
        performSegue(withIdentifier: "pinLocation", sender: nil)
    }
    
    func setUpFloatingButton() {
        
        floatingButton = ActionButton(attachedToView: self.view, items: nil, buttonHeight: 50, buttonWidth: 150, buttonType: .Rectangle, position: .BottomRight)
        floatingButton.setTitle(" Offer Parking ", fontsize: 18, forState: UIControl.State())
        floatingButton.backgroundColor = #colorLiteral(red: 0.662745098, green: 0.3294117647, blue: 0.8941176471, alpha: 1)
        floatingButton.fontColor(color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), forState: UIControl.State())
        floatingButton.show()
        
        floatingButton.action = {editButtonItem in self.goToPinLocation()}
        //floatingButton.buttonTappedForSegue("addVehicleVC", self)
    }

}

extension OfferParkingVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.myPins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myspotCell") as? MySpotCell else { return UITableViewCell() }
        
        let pins = DataService.instance.myPins
        let key = Array(pins.keys)[indexPath.row]
        let pin = pins[key]
        
        cell.configureCell(locationpin: pin!)
        
        return cell
    }
    
    
    
}
