//
//  BasicNutrientView.swift
//  Velance
//
//  Created by Jinyoung Kim on 2021/09/15.
//

import UIKit

@IBDesignable
class BasicNutrientView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var remainLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        let bundle = Bundle(for: BasicNutrientView.self)
        let view = bundle.loadNibNamed("BasicNutrientView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        addSubview(view)
    }
}
