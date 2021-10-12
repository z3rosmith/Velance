import UIKit

class ProductForSimilarTasteCVC: UICollectionViewCell {
    
    @IBOutlet weak var productContentView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productVeganTypeLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productTitleLabel.text = nil
        productVeganTypeLabel.text = nil
        productPriceLabel.text = nil
        productRatingLabel.text = nil
    }

    
    private func configure() {
        configureProductContentView()
        
    }
    
    private func configureProductContentView() {
        productContentView.layer.cornerRadius = 15
        
    }
}
