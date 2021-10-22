import Foundation
import SnapKit

class VLStarButton: UIButton {
    
    override  init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        setImage(UIImage(named: Images.starUnfilled), for: .normal)
        isUserInteractionEnabled = true
    }
    
}
