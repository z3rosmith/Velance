import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    var bottomHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bottomHeight = bottomHeight {
            bottomViewHeight.constant = bottomHeight
        }
        
        configureBottomView()
    }

    @IBAction func tap(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension SecondViewController {
    private func configureBottomView() {
        bottomView.layer.cornerRadius = 30
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
