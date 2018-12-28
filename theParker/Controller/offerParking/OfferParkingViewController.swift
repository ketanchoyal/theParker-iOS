import UIKit

class OfferParkingViewController: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = HextoUIColor.instance.hexString(hex: "#4C177D")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 50)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Offer"
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        // Do any additional setup after loading the view.
        
        let DataTime:String = "10:30 AM"
        
//        let stringArray = DataTime.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
//        print(stringArray)
//        let newString = NSArray(array: stringArray).componentsJoined(by: "")
//        let timeout = Int(DataTime)
//        print("HEY GUYS HEY THERE")
//        print(newString)
//
//        let date = Date()
//        let calendar = Calendar.current
//        let day = calendar.component(.day, from: date)
//        let month = calendar.component(.month, from: date)
//        let year = calendar.component(.year, from: date)
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//
//
//        print(day)
//        print(month)
//        print(year)
//        print(hour)
//        print(minutes)
    }

   

}

extension OfferParkingViewController{
    
    
}
