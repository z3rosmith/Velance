import UIKit
import ImageSlideshow

protocol CommunityFeedCVCDelegate: AnyObject {
    func didChooseToReportUser(type: ReportType.Feed, feedId: Int)
    func didChooseToBlockUser(userId: String)
    func didChooseToDeleteMyFeed(feedId: Int)
}

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
    weak var delegate: CommunityFeedCVCDelegate?
    
    var feedId: Int?
    var createdUserUid: String?
    
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
        
        moreButton.addTarget(self, action: #selector(pressedMoreButton), for: .touchUpInside)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTapHeaderView))
        headerView.addGestureRecognizer(tapGR)
    }
    
    private func setupTextView() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        let attributes = [NSAttributedString.Key.paragraphStyle: style]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
        textView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    @objc private func didTapHeaderView() {
        guard let nextVC = parentVC?.storyboard?.instantiateViewController(withIdentifier: "CommunityFeedViewController") as? CommunityFeedViewController else { fatalError() }
        nextVC.isMyFeed = false
        if let userUID = createdUserUid {
            nextVC.userUID = userUID
        }
        parentVC?.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func didTapImage() {
        guard let parentVC = parentVC else { return }
        imageSlideShow.presentFullScreenController(from: parentVC)
    }
    
    @objc private func pressedMoreButton() {

        guard let feedId = feedId, let createdUserUId = createdUserUid else {
            return
        }
        
        if createdUserUId == User.shared.userUid {
            
            let deleteAction = UIAlertAction(
                title: "내 글 삭제하기",
                style: .destructive
            ) { [weak self] _ in
                guard let self = self else { return }
                self.parentVC?.presentAlertWithConfirmAction(
                    title: "내 글을 삭제하시겠어요?",
                    message: ""
                ) { selectedOk in
                    if selectedOk {
                        self.delegate?.didChooseToDeleteMyFeed(feedId: feedId)
                    }
                }
            }
            let actionSheet = UIHelper.createActionSheet(with: [deleteAction], title: nil)
            parentVC?.present(actionSheet, animated: true)
            
            
        } else {
            
            let reportAction = UIAlertAction(
                title: "사용자 신고하기",
                style: .default
            ) { [weak self] _ in
                guard let self = self else { return }
                self.presentReportFeedActionSheet()
            }
            
            let blockAction = UIAlertAction(
                title: "해당 사용자의 글 더 이상 보지 않기",
                style: .default
            ) { [weak self] _ in
                guard let self = self else { return }
                self.parentVC?.presentAlertWithConfirmAction(
                    title: "해당 사용자의 글 보지 않기",
                    message: "해당 사용자의 게시글이 더는 보이지 않도록 설정하시겠습니까? 한 번 설정하면 해제할 수 없습니다."
                ) { selectedOk in
                    if selectedOk {
                        self.delegate?.didChooseToBlockUser(userId: createdUserUId)
                    }
                }
                
            }
            let actionSheet = UIHelper.createActionSheet(with: [reportAction, blockAction], title: nil)

            parentVC?.present(actionSheet, animated: true)
        }
        
        
    }
    
    private func presentReportFeedActionSheet() {
        
        let violentReview = UIAlertAction(
            title: ReportType.Feed.violentFeed.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.reportUser(reportType: ReportType.Feed.violentFeed)
        }
        
        let sexualReview = UIAlertAction(
            title: ReportType.Feed.sexualFeed.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.reportUser(reportType: ReportType.Feed.sexualFeed)
        }
        
        let inappropriateReview = UIAlertAction(
            title: ReportType.Feed.inappropriateFeed.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.reportUser(reportType: ReportType.Feed.inappropriateFeed)
        }
        
        let actionSheet = UIHelper.createActionSheet(with: [violentReview, sexualReview, inappropriateReview], title: "신고 사유 선택")
        parentVC?.present(actionSheet, animated: true)
    }
    
    func reportUser(reportType: ReportType.Feed) {
        guard let feedId = feedId else { return }
        self.delegate?.didChooseToReportUser(type: reportType, feedId: feedId)
    }
}
