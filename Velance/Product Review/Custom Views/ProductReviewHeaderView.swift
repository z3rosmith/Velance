import UIKit
import SnapKit


class ProductReviewHeaderView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let starButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: Images.starFilled), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return button
    }()
    

    lazy var ratingStackView: RatingStackView = {
        let stackView = RatingStackView(arrangedSubviews: [starButton,starButton,starButton,starButton,starButton])
      
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let estimatedPriceGuideLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let estimatedPriceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        return label
    }()
    

    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    

    func configure(productName: String, rating: Int, price: Int) {
        
        estimatedPriceLabel.text = "sd"
    }
}
