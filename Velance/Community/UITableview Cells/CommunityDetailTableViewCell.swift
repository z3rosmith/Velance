import UIKit

protocol CommunityDetailTVCDelegate: AnyObject {
    func didChooseToReportUser(type: ReportType.Reply, replyId: Int)
    func didChooseToBlockUser(userId: String)
    func didChooseToDeleteMyReply(replyId: Int)
}

class CommunityDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    weak var parentVC: UIViewController?
    weak var delegate: CommunityDetailTVCDelegate?
    
    var replyId: Int?
    var createdUserUid: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
}

extension CommunityDetailTableViewCell {
    
    private func configureUI() {
        cellView.layer.cornerRadius = 15
        cellView.layer.shadowRadius = 3
        cellView.layer.shadowOpacity = 0.3
        cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellView.layer.shadowColor = UIColor.darkGray.cgColor
        userImageView.layer.cornerRadius = userImageView.frame.height/2
    
        moreButton.addTarget(self, action: #selector(pressedMoreButton), for: .touchUpInside)
    }
    
    @objc private func pressedMoreButton() {
        
        guard let replyId = replyId, let createdBy = createdUserUid else {
            return
        }
        
        if createdBy == User.shared.userUid {
            
            let deleteAction = UIAlertAction(
                title: "내 댓글 삭제하기",
                style: .destructive
            ) { [weak self] _ in
                guard let self = self else { return }
                self.parentVC?.presentAlertWithConfirmAction(
                    title: "내 글을 삭제하시겠어요?",
                    message: ""
                ) { selectedOk in
                    if selectedOk {
                        self.delegate?.didChooseToDeleteMyReply(replyId: replyId)
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
                        self.delegate?.didChooseToBlockUser(userId: createdBy)
                    }
                }
                
            }
            let actionSheet = UIHelper.createActionSheet(with: [reportAction, blockAction], title: nil)

            parentVC?.present(actionSheet, animated: true)
        }
        
    }
    
    private func presentReportFeedActionSheet() {
        
        let violentReview = UIAlertAction(
            title: ReportType.Reply.violentComment.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.reportUser(reportType: ReportType.Reply.violentComment)
        }
        
        let sexualReview = UIAlertAction(
            title: ReportType.Reply.sexualComment.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.reportUser(reportType: ReportType.Reply.sexualComment)
        }
        
        let inappropriateReview = UIAlertAction(
            title: ReportType.Reply.inappropriateComment.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.reportUser(reportType: ReportType.Reply.inappropriateComment)
        }
        
        let actionSheet = UIHelper.createActionSheet(with: [violentReview, sexualReview, inappropriateReview], title: "신고 사유 선택")
        parentVC?.present(actionSheet, animated: true)
    }
    
    func reportUser(reportType: ReportType.Reply) {
        guard let replyId = replyId else { return }
        delegate?.didChooseToReportUser(type: reportType, replyId: replyId)
    }
}
