import UIKit
import ImageSlideshow

class CommunityFeedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var imageSlideShow: ImageSlideshow!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var userVegetarianTypeLabel: UILabel!
    @IBOutlet weak var recipeLabledView: UIView!
    
    weak var parentVC: UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        setupTextView()
    }
}

extension CommunityFeedCollectionViewCell {
    
    private func configureUI() {
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        imageSlideShow.contentScaleMode = .scaleAspectFill
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageSlideShow.addGestureRecognizer(gestureRecognizer)
        
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        
        recipeLabledView.layer.cornerRadius = 18
        
        backgroundColor = .clear
        layer.masksToBounds = false
        cellView.layer.masksToBounds = true
        cellView.layer.cornerRadius = 20
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    private func setupTextView() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        let attributes = [NSAttributedString.Key.paragraphStyle: style]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
        textView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    @objc private func didTapImage() {
        guard let parentVC = parentVC else { return }
        imageSlideShow.presentFullScreenController(from: parentVC)
    }
}
