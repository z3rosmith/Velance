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
    
    weak var currentVC: UIViewController?
    
    //MARK: - Constants
    
    fileprivate struct Metrics {
        static let reviewImageViewHeight: CGFloat = 160
    }
    
    
    //MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        configureContainerView()
        configureReviewImageSlideShow()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reviewImageViewHeight.constant = Metrics.reviewImageViewHeight
    }
    
    //MARK: - Target Methods
    
    @objc private func pressedImage() {
        reviewImageSlideShow.presentFullScreenController(from: currentVC ?? UIViewController())
    }

    //MARK: - UI Configuration
    
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
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.pressedImage)
        )
        reviewImageSlideShow.addGestureRecognizer(recognizer)
    }
    
    
    
    
}
