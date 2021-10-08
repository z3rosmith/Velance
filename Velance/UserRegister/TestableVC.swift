import UIKit

class TestableVC: UIViewController {

    
    @IBOutlet weak var typeButton: VLTypeOptionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeButton.isSelected = false
    }
    
    @IBAction func pressedBtn(_ sender: UIButton) {
        
        print("✏️ isSelected: \(sender.isSelected)")
        
        if sender.isSelected {
            
            sender.isSelected = !sender.isSelected
            
        } else {
            
            sender.isSelected = !sender.isSelected
        }
        
    }
    
}
