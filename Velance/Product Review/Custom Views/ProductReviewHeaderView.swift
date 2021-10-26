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
    
    lazy var priceLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [estimatedPriceGuideLabel, estimatedPriceLabel])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    
    let allergyGuideLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.text = "아래와 같은 알레르기를 가진 사람들이 이 제품을 먹었어요! 구매 전 참고 부탁드려요 :)"
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    let allergyButton1 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[0])
    let allergyButton2 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[1])
    let allergyButton3 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[2])
    let allergyButton4 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[3])
    let allergyButton5 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[4])
    
    lazy var allergyStack1: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allergyButton1, allergyButton2, allergyButton3, allergyButton4, allergyButton5])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        return stackView
    }()
    
    let allergyButton6 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[5])
    let allergyButton7 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[6])
    let allergyButton8 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[7])
    let allergyButton9 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[8])
    
    lazy var allergyStack2: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allergyButton6, allergyButton7, allergyButton8, allergyButton9])
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        return stackView
    }()
    
    let allergyButton10 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[9])
    let allergyButton11 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[10])
    let allergyButton12 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[11])
    let allergyButton13 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[12])
    
    
    lazy var allergyStack3: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allergyButton10, allergyButton11, allergyButton12, allergyButton13])
        stackView.axis = .horizontal
        stackView.spacing = 3
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        return stackView
    }()
    

    lazy var allergyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allergyStack1, allergyStack2, allergyStack3])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "리뷰"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    
    //MARK: - Configuration
    
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
        addSubview(priceLabelStackView)
        addSubview(allergyGuideLabel)
        addSubview(allergyStackView)
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
        
        priceLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10.5)
            make.right.equalTo(self.snp.right).offset(-Metrics.labelPadding)
        }
        
        allergyGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStackView.snp.bottom).offset(15)
            make.left.equalTo(self.snp.left).offset(Metrics.labelPadding)
            make.right.equalTo(self.snp.right).offset(-Metrics.labelPadding)
        }
        
        allergyStackView.snp.makeConstraints { make in
            make.top.equalTo(allergyGuideLabel.snp.bottom).offset(15)
            make.left.equalTo(self.snp.left).offset(Metrics.labelPadding)
            make.right.equalTo(self.snp.right).offset(-Metrics.labelPadding)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(allergyStackView.snp.bottom).offset(10)
            make.left.equalTo(self.snp.left).offset(Metrics.labelPadding)
        }
    }
}

class VLAllergyCheckButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    init(buttonTitle: String) {
        super.init(frame: .zero)
        setTitle(buttonTitle, for: .normal)
        configure()
    }
    
    func configure() {
        setTitleColor(.darkGray, for: .normal)
        setTitleColor(.darkGray, for: .selected)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.85
        titleLabel?.lineBreakMode = .byTruncatingTail
        setImage(UIImage(systemName: "square"), for: .normal)
        setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        tintColor = .darkGray
        isUserInteractionEnabled = false

    }
}
