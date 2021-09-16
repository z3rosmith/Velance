
import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemContentView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemEstimatedCookTimeLabel: UILabel!
    @IBOutlet weak var itemRecipeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        itemTitleLabel.text = nil
        itemEstimatedCookTimeLabel.text = nil
    }
    
    @objc private func pressedSeeRecipeButton() {
        
    }
    
    private func configure() {
        configureItemContentView()
        configureItemImageView()
        configureItemTitleLabel()
        configureItemEstimatedCookTimeLabel()
        configureItemRecipeButton()
    }
    
    private func configureItemContentView() {
        itemContentView.layer.borderWidth = 0.5
        itemContentView.layer.borderColor = UIColor.systemGray4.cgColor
        itemContentView.layer.cornerRadius = 15
    }
    
    private func configureItemImageView() {
        
    }
    
    private func configureItemTitleLabel() {
        
    }
    
    private func configureItemEstimatedCookTimeLabel() {
    
    }
    
    private func configureItemRecipeButton() {
        itemRecipeButton.layer.cornerRadius = 12
        itemRecipeButton.addBounceAnimation()
        itemRecipeButton.addTarget(
            self,
            action: #selector(pressedSeeRecipeButton),
            for: .touchUpInside
        )
    }

}
