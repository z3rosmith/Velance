import UIKit

class VLFloatingButton: UIButton {
    
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
    
    private func configure() {
        layer.cornerRadius = frame.height / 2
        backgroundColor = UIColor(named: "388203") ?? .systemGreen
//        backgroundColor = UIColor(named: Colors.tabBarSelectedColor) ?? .systemGreen
    }
}
