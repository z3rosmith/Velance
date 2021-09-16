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
        
        
//        let bundle = Bundle.init(for: classForCoder)
//        let view = bundle.loadNibNamed(
//            "VLBottomView",
//            owner: self,
//            options: nil
//        )?.first as! UIView
//        view.frame = self.bounds
//        view.layer.cornerRadius = 30
//        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        addSubview(view)
    }

}
