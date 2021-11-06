import UIKit
import TagListView

class CommunityCollectionReusableView2: UICollectionReusableView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var editUserImageButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userCategoryLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var editUserinfoButton: UIButton!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = contentView.bounds
        gradient.cornerRadius = 30
        gradient.colors = [UIColor(named: "73B818")!.cgColor, UIColor(named: "B3E570")!.cgColor]
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        return gradient
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }
}

extension CommunityCollectionReusableView2 {
    
    private func configureUI() {
        contentView.layer.cornerRadius = 30
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.layer.masksToBounds = true
        editUserImageButton.layer.cornerRadius = editUserImageButton.frame.height/2
        editUserImageButton.layer.masksToBounds = true
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        tagListView.textFont = .systemFont(ofSize: 16, weight: .medium)
        tagListView.alignment = .leading
        tagListView.textColor = UIColor(named: "4D8800")!
        tagListView.tagBackgroundColor = UIColor(named: "BADE8A")!
        tagListView.cornerRadius = 10
    }
}
