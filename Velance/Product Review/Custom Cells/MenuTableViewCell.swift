import UIKit

protocol MenuTableViewCellDelegate: AnyObject {
    // 좋아요 기능 추가?
}

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet var menuImageView: UIImageView!
    @IBOutlet var menuNameLabel: UILabel!
    @IBOutlet var menuCautionLabel: UILabel!
    @IBOutlet var likeButton: VLSocialButton!
    @IBOutlet var menuPriceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        configureImageView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        menuImageView.image = nil
        menuNameLabel.text = nil
        menuCautionLabel.text = nil
        menuPriceLabel.text = nil
    }
    
    func configureImageView() {
        menuImageView.contentMode = .scaleAspectFill
        menuImageView.layer.cornerRadius = 5
        menuImageView.clipsToBounds = true
    }
    
}
