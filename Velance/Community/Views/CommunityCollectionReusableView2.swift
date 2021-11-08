import UIKit
import TagListView

protocol CommunityReusableDelegate: AnyObject {
    func didChooseToEditProfileImage()
}

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
    @IBOutlet weak var followButton: UIButton!
    
    weak var delegate: CommunityReusableDelegate?
    
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
        
        editUserinfoButton.addTarget(
            self,
            action: #selector(pressedEditUserInfoButton),
            for: .touchUpInside
        )
        
        editUserImageButton.addTarget(
            self,
            action: #selector(pressedEditUserImageButton),
            for: .touchUpInside
        )
        
        followButton.setImage(UIImage(named: "NotFollowButton"), for: .normal)
        followButton.setImage(UIImage(named: "FollowButton"), for: .selected)
    }
    
    @objc private func pressedEditUserInfoButton() {
        
        if let currentVC = UIApplication.topViewController() {
            
            guard let editVC = InputUserInfoForRegisterViewController.instantiate() as? InputUserInfoForRegisterViewController else { return }
            editVC.isForEditingUser = true
            
            let navController = UINavigationController(rootViewController: editVC)
            navController.navigationBar.tintColor = .white
            currentVC.present(navController, animated: true)
        }
    }
    
    @objc private func pressedEditUserImageButton() {
        delegate?.didChooseToEditProfileImage()
    }
}
