import UIKit
import ImageSlideshow

protocol ProductReviewTableViewCellDelegate: AnyObject {
    func didBlockUser()
    func didReportUser()
}

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
    weak var delegate: ProductReviewTableViewCellDelegate?
    
    //MARK: - Constants
    
    fileprivate struct Metrics {
        static let reviewImageViewHeight: CGFloat = 160
    }
    
    //MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
        configureContainerView()
        configureReviewImageSlideShow()
        configureShowMoreButton()
        configureProfileImageView()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reviewImageViewHeight.constant = Metrics.reviewImageViewHeight
    }
    
    //MARK: - Target Methods
    
    @objc private func pressedImage() {
        reviewImageSlideShow.presentFullScreenController(from: currentVC ?? UIViewController())
    }

    @objc private func pressedShowMoreButton() {
        
        let reportAction = UIAlertAction(
            title: "사용자 신고하기",
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            
        }
        
        let blockAction = UIAlertAction(
            title: "해당 사용자의 글 더 이상 보지 않기",
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            
        }
        let actionSheet = UIHelper.createActionSheet(with: [reportAction, blockAction], title: nil)

        currentVC?.present(actionSheet, animated: true)
    }
    
    func reportUser() {
        
    }
    
    func blockUser() {
        
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
        reviewImageSlideShow.zoomEnabled = true
        
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(self.pressedImage)
        )
        reviewImageSlideShow.addGestureRecognizer(recognizer)
    }
    
    func configureShowMoreButton() {
        showMoreButton.addTarget(
            self,
            action: #selector(pressedShowMoreButton),
            for: .touchUpInside
        )
    }
    
    func configureProfileImageView() {

        profileImageView.layer.borderColor = UIColor.darkGray.cgColor
        profileImageView.contentMode = .scaleAspectFit
    }
}
