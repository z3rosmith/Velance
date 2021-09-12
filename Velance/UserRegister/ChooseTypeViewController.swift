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
    @IBOutlet var buttons: [UIButton]!
    
    private var selectedIndex: Int = 0
    private var didSelectVeganType: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    @IBAction func pressedNextButton(_ sender: UIButton) {
        
        if !didSelectVeganType {
            presentVLAlert(title: "채식 유형 선택", message: "채식 유형을 선택해주세요!", buttonTitle: "확인")
            return
        }
        
        UserRegisterValues.shared.veganType = selectedIndex
        
        guard let vc = storyboard?.instantiateViewController(
                identifier: StoryboardID.chooseDetailVC
        ) as? ChooseDetailViewController else { fatalError() }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pressedVeganType(_ sender: UIButton) {
        
        didSelectVeganType = true
        
        buttonViews[selectedIndex].backgroundColor = UIColor(named: Colors.appTintColor)
        buttons[selectedIndex].setImage(UIImage(named: Images.veganTypesUnselected[selectedIndex]), for: .normal)
        
        selectedIndex = sender.tag
        
        buttonViews[selectedIndex].backgroundColor = UIColor(named: Colors.buttonSelectedColor)
        buttons[selectedIndex].setImage(UIImage(named: Images.veganTypesSelected[selectedIndex]), for: .normal)
        
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

