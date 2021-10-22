import UIKit
import ImageSlideshow

class ProductReviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var ratingView: RatingStackView!
    @IBOutlet weak var reviewImageSlideShow: ImageSlideshow!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var reviewImageViewHeight: NSLayoutConstraint!
    
    
    fileprivate struct Metrics {
        static let reviewImageViewHeight: CGFloat = 160
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureContainerView()
        configureReviewImageSlideShow()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reviewImageViewHeight.constant = Metrics.reviewImageViewHeight
    }
    
    func configureContainerView() {
        containerView.layer.cornerRadius = 15
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = false
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 3)
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    func configureReviewImageSlideShow() {
        reviewImageSlideShow.contentScaleMode = .scaleAspectFill
        reviewImageSlideShow.layer.cornerRadius = 10
        reviewImageSlideShow.zoomEnabled = true
        
    }
    
}
