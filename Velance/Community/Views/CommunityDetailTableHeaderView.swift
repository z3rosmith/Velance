import UIKit
import ImageSlideshow

class CommunityDetailTableHeaderView: UIView {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
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
        
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        
        imageSlideShow.contentScaleMode = .scaleAspectFill
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func didTapImage() {
        guard let parentVC = parentVC else { return }
        imageSlideShow.presentFullScreenController(from: parentVC)
    }
}
