import UIKit

class CommunityDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
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
    }
}
