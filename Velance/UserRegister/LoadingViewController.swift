import UIKit
import Gifu
import SnapKit

class LoadingViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var animatedLoadingImageView: GIFImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    private let labelFont: UIFont = .systemFont(ofSize: 20)
    
    static var storyboardName: String {
        StoryboardName.userRegister
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animatedLoadingImageView.animate(withGIFNamed: "LoadingAnimation")

        loadingLabel.attributedText = NSMutableAttributedString()
            .normal("당신에게 ", with: labelFont)
            .bold("딱 필요한\n비건 서비스를 ", with: .systemFont(ofSize: 23, weight: .bold))
            .normal("제작 중입니다...", with: labelFont)
        
        
    }



}
