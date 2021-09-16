import UIKit

@IBDesignable
class VLBottomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        configure()
    }
    
    private func configure() {
        backgroundColor = UIColor(named: Colors.appBackgroundColor)
        layer.cornerRadius = 30
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    
    }

}
