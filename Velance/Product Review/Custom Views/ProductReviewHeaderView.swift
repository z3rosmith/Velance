import UIKit
import SnapKit

class ProductReviewHeaderView: UIView {
    
    //MARK: - Constants
    fileprivate struct Metrics {
        static let labelPadding: CGFloat = 24
    }
    
    //MARK: - UI
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    let starButton1 = VLStarButton()
    let starButton2 = VLStarButton()
    let starButton3 = VLStarButton()
    let starButton4 = VLStarButton()
    let starButton5 = VLStarButton()
    
    lazy var ratingStackView: RatingStackView = {
        let stackView = RatingStackView(arrangedSubviews: [starButton1,starButton2,starButton3,starButton4,starButton5])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    let estimatedPriceGuideLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .darkGray
        label.text = "예상 가격 :"
        return label
    }()
    
    let estimatedPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "리뷰"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    func configure(productName: String, rating: Int, price: Int) {
        
        titleLabel.text = productName
        ratingStackView.setStarsRating(rating: rating)
        ratingLabel.text = "\(Double(rating))"
        estimatedPriceLabel.text = "\(price) 원"
        makeConstraints()
    }
    
    func makeConstraints() {
        
        addSubview(titleLabel)
        addSubview(ratingStackView)
        addSubview(ratingLabel)
        addSubview(estimatedPriceGuideLabel)
        addSubview(estimatedPriceLabel)
        addSubview(reviewLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(12)
            make.left.equalTo(self.snp.left).offset(Metrics.labelPadding)
            make.right.equalTo(self.snp.right).offset(-Metrics.labelPadding)
        }
        
        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(self.snp.left).offset(Metrics.labelPadding)
            make.width.equalTo(100)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9.3)
            make.left.equalTo(ratingStackView.snp.right).offset(6)
        }
        
        estimatedPriceGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStackView.snp.bottom).offset(12)
            make.left.equalTo(self.snp.left).offset(Metrics.labelPadding)
        }
        
        estimatedPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStackView.snp.bottom).offset(12)
            make.left.equalTo(estimatedPriceGuideLabel.snp.right).offset(4)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.left.equalTo(self.snp.left).offset(Metrics.labelPadding)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
        }
    }
}
