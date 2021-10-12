import UIKit

class PopularProductCVC: UICollectionViewCell {

    @IBOutlet weak var productContentView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productVeganTypeLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var ratingStackView: RatingStackView!
    
    fileprivate struct Metrics {
        static let viewCornerRadius: CGFloat = 15
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productTitleLabel.text = nil
        productVeganTypeLabel.text = nil
        productPriceLabel.text = nil

    }
    
    private func configure() {
        configureProductContentView()
        configureProductImageView()
    }
    
    private func configureProductContentView() {
        productContentView.layer.cornerRadius = Metrics.viewCornerRadius
    
    }
    
    private func configureProductImageView() {
        productImageView.layer.cornerRadius = Metrics.viewCornerRadius
        productImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
