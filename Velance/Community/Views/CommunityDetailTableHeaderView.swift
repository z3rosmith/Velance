import UIKit
import ImageSlideshow

class CommunityDetailTableHeaderView: UIView {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: VLSocialButton!
    @IBOutlet weak var commentButton: VLSocialButton!
    
    weak var parentVC: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        let bundle = Bundle(for: CommunityDetailTableHeaderView.self)
        let view = bundle.loadNibNamed("CommunityDetailTableHeaderView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        addSubview(view)
        
        imageSlideShow.contentScaleMode = .scaleAspectFill
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
        
        likeButton.setLeftImage(image: UIImage(named: "ThumbLogo")!)
        commentButton.setLeftImage(image: UIImage(named: "CommentLogo")!)
    }
    
    @objc private func didTap() {
        guard let parentVC = parentVC else { return }
        imageSlideShow.presentFullScreenController(from: parentVC)
    }
}
