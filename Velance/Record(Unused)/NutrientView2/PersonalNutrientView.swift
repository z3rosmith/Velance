import UIKit

@IBDesignable
class PersonalNutrientView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        let bundle = Bundle(for: PersonalNutrientView.self)
        let view = bundle.loadNibNamed("PersonalNutrientView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
}
