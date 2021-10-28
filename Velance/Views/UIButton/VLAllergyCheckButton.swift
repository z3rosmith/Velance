import UIKit

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
