import UIKit

class SimilarUserCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userStyleLabel: UILabel!
    @IBOutlet weak var followButton: VLGradientButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
        usernameLabel.text = nil
        userStyleLabel.text = nil
    }
}

extension SimilarUserCollectionViewCell {
    
    private func setupUI() {
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
        followButton.setTitle("팔로우", for: .normal)
        followButton.setTitle("팔로잉", for: .selected)
    }
}
