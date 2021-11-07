import UIKit
import ImageSlideshow

protocol ProductReviewTableViewCellDelegate: AnyObject {
    func didChooseToReportUser(type: ReportType.Review, reviewId: Int)
    func didChooseToBlockUser(userId: String)
    func didChooseToDeleteMyReview(reviewId: Int)
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
    
    var reviewId: Int?
    var createdBy: String?
    
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
    }
    
    //MARK: - Target Methods
    
    @objc private func pressedImage() {
        reviewImageSlideShow.presentFullScreenController(from: currentVC ?? UIViewController())
    }

    @objc private func pressedShowMoreButton() {
        
        guard let createdBy = createdBy, let reviewId = reviewId else { return }
        
        if createdBy == User.shared.userUid {
            
            let deleteAction = UIAlertAction(
                title: "내 리뷰 삭제하기",
                style: .destructive
            ) { [weak self] _ in
                guard let self = self else { return }
                self.currentVC?.presentAlertWithConfirmAction(
                    title: "리뷰를 삭제하시겠어요?",
                    message: "") { selectedOk in
                        if selectedOk {
                            self.delegate?.didChooseToDeleteMyReview(reviewId: reviewId)
                        }
                    }
            }
            let actionSheet = UIHelper.createActionSheet(with: [deleteAction], title: nil)
            currentVC?.present(actionSheet, animated: true)
            
        } else {
            
            let reportAction = UIAlertAction(
                title: "사용자 신고하기",
                style: .default
            ) { [weak self] _ in
                guard let self = self else { return }
                self.presentReportReviewActionSheet()
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
      
    }
    
    private func presentReportReviewActionSheet() {
    
        let violentReview = UIAlertAction(
            title: ReportType.Review.violentReview.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.reportUser(reportType: ReportType.Review.violentReview)
        }
        
        let sexualReview = UIAlertAction(
            title: ReportType.Review.sexualReview.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.reportUser(reportType: ReportType.Review.sexualReview)
        }
        
        let inappropriateReview = UIAlertAction(
            title: ReportType.Review.inappropriateReview.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.reportUser(reportType: ReportType.Review.inappropriateReview)
        }
        
        let actionSheet = UIHelper.createActionSheet(with: [violentReview, sexualReview, inappropriateReview], title: "신고 사유 선택")
        currentVC?.present(actionSheet, animated: true)
    }
    
    func reportUser(reportType: ReportType.Review) {
        guard let reviewId = self.reviewId else { return }
        self.delegate?.didChooseToReportUser(type: reportType, reviewId: reviewId)
    }
    
    func blockUser() {
        
    }
    
    //MARK: - UI Configuration
    
    func configureContainerView() {
        containerView.layer.cornerRadius = 15
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = false
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
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
