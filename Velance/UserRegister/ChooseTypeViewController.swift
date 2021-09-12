//
//  ChooseTypeViewController.swift
//  Velance
//
//  Created by Kevin Kim on 2021/09/11.
//

import UIKit

class ChooseTypeViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var buttonViews: [UIView]!
    
    private var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    @IBAction func pressedNextButton(_ sender: UIButton) {
        
        guard let vc = storyboard?.instantiateViewController(
                identifier: StoryboardID.chooseDetailVC
        ) as? ChooseDetailViewController else { fatalError() }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pressedVeganType(_ sender: UIButton) {
        buttonViews[selectedIndex].backgroundColor = UIColor(named: Color.appTintColor)
        selectedIndex = sender.tag
        buttonViews[selectedIndex].backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7254901961, blue: 0.2235294118, alpha: 1)
        
    }
    
    
    

}

//MARK: - UI Configuration

extension ChooseTypeViewController {
    
    private func configure() {
        configureBottomView()
        configureButtonViews()
    }
    
    private func configureBottomView() {
        bottomView.layer.cornerRadius = 30
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func configureButtonViews() {
        buttonViews.forEach { view in
            view.layer.cornerRadius = view.frame.height / 2
            view.layer.borderWidth = 0.3
            view.layer.borderColor = #colorLiteral(red: 0.5058823529, green: 0.7254901961, blue: 0.2235294118, alpha: 1)
        }
    }
    
}

