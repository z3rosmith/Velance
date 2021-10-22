import UIKit
import SDWebImage

class LoadingViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var animatedLoadingImageView: SDAnimatedImageView!
    
    
    static var storyboardName: String {
        StoryboardName.userRegister
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    

        let animatedImage = SDAnimatedImage(named: "LoadingAnimation")
        animatedLoadingImageView.image = animatedImage
        
    }
    
    private func configure() {
        
    }
}
