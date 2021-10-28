import UIKit

class ProductForSimilarTasteCVC: UICollectionViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productRatingLabel: UILabel!
    
    fileprivate struct Metrics {
        static let viewCornerRadius: CGFloat = 15
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("✏️ awakeFromNib ")
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        productTitleLabel.text = nil
    
        productPriceLabel.text = nil
        productRatingLabel.text = nil
    }

    
    private func configure() {
        configureContainerView()
        configureProductImageView()
        
    }
    
    private func configureContainerView() {
        containerView.layer.cornerRadius = Metrics.viewCornerRadius
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = false
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    private func configureProductImageView() {
        productImageView.layer.cornerRadius = Metrics.viewCornerRadius
        productImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
}
