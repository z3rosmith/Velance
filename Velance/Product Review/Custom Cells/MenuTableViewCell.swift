import UIKit

protocol MenuTableViewCellDelegate: AnyObject {
    func didChooseToLikeMenu(menuId: Int, indexPath: IndexPath)
    func didChooseToCancelLikeMenu(menuId: Int, indexPath: IndexPath)
}

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet var menuImageView: UIImageView!
    @IBOutlet var menuNameLabel: UILabel!
    @IBOutlet var menuCautionLabel: UILabel!
    @IBOutlet var likeButton: VLSocialButton!
    @IBOutlet var menuPriceLabel: UILabel!
    
    var menuId: Int?
    var indexPath: IndexPath?
    
    weak var delegate: MenuTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureImageView()
        configureLikeButton()
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
    
    func configureLikeButton() {
        likeButton.addTarget(self, action: #selector(pressedMenuLikeButton), for: .touchUpInside)
    }
    
    @objc private func pressedMenuLikeButton() {
        guard
            let menuId = menuId,
            let indexPath = indexPath
        else { return }
        
    
        if likeButton.isSelected {
            delegate?.didChooseToCancelLikeMenu(menuId: menuId, indexPath: indexPath)
        } else {
            delegate?.didChooseToLikeMenu(menuId: menuId, indexPath: indexPath)
       
        }
    }
    
    
    
    
    
}
