import UIKit

class MyCarsVC: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    @IBOutlet weak var carTable: UITableView!
    
    var floatingButton : ActionButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpFloatingButton()
        
        DataService.instance.getMyCars { (success) in
            if success {
                self.carTable.reloadData()
            }
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        carTable.delegate = self
        carTable.dataSource = self
        
    }

    @IBAction func addVehicleTapped(_ sender: Any) {
        goToAddCarVC()
    }
    
    func goToAddCarVC() {
        performSegue(withIdentifier: "addVehicleVC", sender: nil)
    }
    
    func setUpFloatingButton() {
        
        floatingButton = ActionButton(attachedToView: self.view, items: nil)
        floatingButton.setTitle("+", forState: UIControl.State())
        floatingButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        floatingButton.action = {editButtonItem in self.goToAddCarVC()}
        //floatingButton.buttonTappedForSegue("addVehicleVC", self)
    }
    
}

extension MyCarsVC{
    
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
}

extension MyCarsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.myCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "carInfoCell") as? CarInfoCell else { return UITableViewCell() }
        
        let cars = DataService.instance.myCars
        let key = Array(cars.keys)[indexPath.row]
        let car = cars[key]
        
        cell.configureCell(car: car!)
        
        return cell
    }
}
