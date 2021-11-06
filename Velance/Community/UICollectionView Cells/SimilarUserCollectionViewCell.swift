import UIKit

class SimilarUserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userStyleLabel: UILabel!
    @IBOutlet weak var followButton: VLGradientButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
        usernameLabel.text = nil
        userStyleLabel.text = nil
    }
}

extension SimilarUserCollectionViewCell {
    
    private func configureUI() {
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        followButton.setTitle("팔로우", for: .normal)
        followButton.setTitle("팔로잉", for: .selected)
        
        backgroundColor = .clear
        layer.masksToBounds = false
        cellView.layer.cornerRadius = 20
        cellView.layer.shadowRadius = 3
        cellView.layer.shadowOpacity = 0.2
        cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellView.layer.shadowColor = UIColor.darkGray.cgColor
    }
}
