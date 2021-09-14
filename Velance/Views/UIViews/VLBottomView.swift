import UIKit

@IBDesignable
class VLBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle.init(for: classForCoder)
        let view = bundle.loadNibNamed(
            "VLBottomView",
            owner: self,
            options: nil
        )?.first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
    
    

}
