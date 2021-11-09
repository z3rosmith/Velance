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
        label.numberOfLines = 1
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
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.text = "이 제품에 포함된 알러지 유발성분 정보"
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
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    let allergyButton6 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[5])
    let allergyButton7 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[6])
    let allergyButton8 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[7])
    let allergyButton9 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[8])
    let allergyButton10 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[9])
    
    lazy var allergyStack2: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allergyButton6, allergyButton7, allergyButton8, allergyButton9, allergyButton10])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    let allergyButton11 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[10])
    let allergyButton12 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[11])
    let allergyButton13 = VLAllergyCheckButton(buttonTitle: UserOptions.allergyOptions[12])

    lazy var allergyStack3: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allergyButton11, allergyButton12, allergyButton13])
        allergyButton11.widthAnchor.constraint(equalToConstant: 62).isActive = true
        allergyButton12.widthAnchor.constraint(equalToConstant: 62).isActive = true
        allergyButton13.widthAnchor.constraint(equalToConstant: 62).isActive = true
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()
    

    lazy var allergyStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [allergyStack1, allergyStack2, allergyStack3])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .equalCentering
        stackView.alignment = .fill
        return stackView
    }()
    
    let allergyStackContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white       // important!
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0, height: 1.5)
        view.layer.shadowColor = UIColor.lightGray.cgColor
        return view
    }()

    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "리뷰"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var allergyButtonArray: [VLAllergyCheckButton] = [
        allergyButton1, allergyButton1, allergyButton2, allergyButton3, allergyButton4,
        allergyButton5, allergyButton6, allergyButton7, allergyButton8,
        allergyButton9, allergyButton10, allergyButton11, allergyButton12, allergyButton13
    ]
    
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 0.8
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 15
        return blurView
    }()
    
    let noAllergyLabel: UILabel = {
        let label = UILabel()
        label.text = "알러지 유발 성분이 없거나 정보가 아직 업데이트 되지 않았어요.\nVelance 팀이 검토 후 업데이트 하도록 할게요 :)"
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .darkGray
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.textAlignment = .center
        return label
    }()
    
    
    //MARK: - Configuration
    
    func configure(productName: String, rating: Int, price: Int, productAllergyGroup: [ProductAllergyGroups]?) {
        
        titleLabel.text = productName
        ratingStackView.setStarsRating(rating: rating)
        ratingLabel.text = "\(Double(rating))"
        estimatedPriceLabel.text = "\(price) 원"
        
        makeConstraints()
        
        if let productAllergyGroup = productAllergyGroup {
            productAllergyGroup.forEach { productAllergy in
                self.allergyButtonArray[productAllergy.allergyType.allergyTypeId].isSelected.toggle()
            }
            if productAllergyGroup.isEmpty {
                addBlurView()
            }
        }
    }
    
    func addBlurView() {
        
        allergyStackContainerView.addSubview(blurView)
        allergyStackContainerView.addSubview(noAllergyLabel)

        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        
        noAllergyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

    }
    
    func makeConstraints() {
        
        addSubview(titleLabel)
        addSubview(ratingStackView)
        addSubview(ratingLabel)
        addSubview(priceLabelStackView)
        addSubview(allergyGuideLabel)
        addSubview(allergyStackContainerView)
        allergyStackContainerView.addSubview(allergyStackView)
        addSubview(reviewLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.left.equalToSuperview().offset(Metrics.labelPadding)
            make.right.equalToSuperview().offset(-Metrics.labelPadding)
        }
        
        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(Metrics.labelPadding)
            make.width.equalTo(100)
        }

        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(13.2)
            make.left.equalTo(ratingStackView.snp.right).offset(6)
        }

        priceLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14.3)
            make.right.equalToSuperview().offset(-Metrics.labelPadding)
        }

        allergyGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingStackView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(Metrics.labelPadding)
        }
        
    
        reviewLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Metrics.labelPadding)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        allergyStackContainerView.snp.makeConstraints { make in
            make.top.equalTo(allergyGuideLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(Metrics.labelPadding)
            make.bottom.equalTo(reviewLabel.snp.top).offset(-12)
        }
        
        allergyStackView.snp.makeConstraints { make in
            make.left.equalTo(allergyStackContainerView.snp.left).offset(15)
            make.right.equalTo(allergyStackContainerView.snp.right).offset(-15)
            make.top.equalTo(allergyStackContainerView.snp.top).offset(12)
            make.bottom.equalTo(allergyStackContainerView.snp.bottom).offset(-12)
        }
        

    
    }
}

