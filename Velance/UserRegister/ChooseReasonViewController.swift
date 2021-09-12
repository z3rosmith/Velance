//
//  ChooseReasonViewController.swift
//  Velance
//
//  Created by Kevin Kim on 2021/09/11.
//

import UIKit

class ChooseReasonViewController: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var reasonButtons: [UIButton]!
    
    private var selectedReasonIndex: Int = 0
    private var didSelectReason: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    @IBAction func pressedPreviousButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressedNextButton(_ sender: UIButton) {
        
        if !didSelectReason {
            presentVLAlert(title: "앱 사용 이유 선택", message: "앱을 사용하는 이유를 하나 선택해주세요.", buttonTitle: "확인")
            return
        }
        
        UserRegisterValues.shared.reason = selectedReasonIndex
    }
    
    @IBAction func pressedReasonButton(_ sender: UIButton) {
        
        didSelectReason = true
        
        reasonButtons[selectedReasonIndex].backgroundColor = UIColor(named: Colors.appTintColor)
        reasonButtons[selectedReasonIndex].setTitleColor(UIColor(named: Colors.buttonSelectedColor), for: .normal)
        
        selectedReasonIndex = sender.tag
        
        reasonButtons[selectedReasonIndex].backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7254901961, blue: 0.2235294118, alpha: 1)
        reasonButtons[selectedReasonIndex].setTitleColor(.white, for: .normal)
    }

}

//MARK: - UI Configuration

extension ChooseReasonViewController {
    
    private func configure() {
        configureBottomView()
        configureReasonButtons()
    }
    
    private func configureBottomView() {
        bottomView.layer.cornerRadius = 30
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func configureReasonButtons() {
        reasonButtons.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
}
