import UIKit
import ImageSlideshow

class CommunityFeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var likeButton: VLSocialButton!
    @IBOutlet weak var commentButton: VLSocialButton!
    @IBOutlet weak var userVegetarianTypeLabel: UILabel!
    @IBOutlet weak var recipeLabledView: UIView!
    
    weak var parentVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
}

extension CommunityFeedCollectionViewCell {
    
    private func setupUI() {
        layer.cornerRadius = 20
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        imageSlideShow.contentScaleMode = .scaleAspectFill
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
        
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        
        likeButton.setLeftImage(image: UIImage(named: "ThumbLogo")!)
        commentButton.setLeftImage(image: UIImage(named: "CommentLogo")!)
        
        recipeLabledView.layer.cornerRadius = 18
    }
    
    @objc private func didTap() {
        guard let parentVC = parentVC else { return }
        imageSlideShow.presentFullScreenController(from: parentVC)
    }
}
