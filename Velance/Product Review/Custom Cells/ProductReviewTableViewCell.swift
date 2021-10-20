import UIKit
import ImageSlideshow

class ProductReviewTableViewCell: UITableViewCell {
    
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
  
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        reviewImageViewHeight.constant = Metrics.reviewImageViewHeight
    }

    
}
