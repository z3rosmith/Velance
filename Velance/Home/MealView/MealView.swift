//
//  MealView.swift
//  Velance
//
//  Created by Jinyoung Kim on 2021/09/16.
//

import UIKit

@IBDesignable
class MealView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        let bundle = Bundle(for: MealView.self)
        let view = bundle.loadNibNamed("MealView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        addSubview(view)
        
        view.layer.cornerRadius = 15
        plusButton.layer.cornerRadius = 20
    }
}
