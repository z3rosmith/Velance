import UIKit

class VLGradientButton: UIButton {

    private lazy var gradient: CAGradientLayer = {
        let buttonGradient = CAGradientLayer()
        buttonGradient.frame = self.bounds
        buttonGradient.cornerRadius = buttonGradient.frame.height / 2
        buttonGradient.colors = [UIColor(named: Colors.ovalButtonGradientLeft)!.cgColor, UIColor(named: Colors.ovalButtonGradientRight)!.cgColor]
        
        buttonGradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        buttonGradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        buttonGradient.frame = self.bounds
        return buttonGradient
    }()
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected {
                self.layer.insertSublayer(self.gradient, at: 0)
            } else {
                self.gradient.removeFromSuperlayer()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }

    
    func configure() {
        layer.borderWidth = 0.3
        layer.cornerRadius = frame.height / 2
        titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.1
        titleLabel?.lineBreakMode = .byTruncatingTail
        
    }

}
