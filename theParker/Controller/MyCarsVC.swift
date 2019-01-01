import UIKit

class MyCarsVC: UIViewController {

    @IBOutlet weak var menu: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = HextoUIColor.instance.hexString(hex: "#4C177D")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 50)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "THE PARKER"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        DataService.instance.getGlobalLocationPins { (success) in
            print(DataService.instance.globalPins)
        }
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
