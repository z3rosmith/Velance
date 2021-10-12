import UIKit

class IdPasswordInputViewController: UIViewController, Storyboarded {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    
    @IBOutlet weak var nextStepButton: UIButton!
    @IBOutlet weak var nextStepArrow: UIButton!
    
    static var storyboardName: String {
        StoryboardName.userRegister
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
}

//MARK: - Target Methods

extension IdPasswordInputViewController {
    
    @objc func pressedNextStepButton() {
        let vc = InputUserInfoForRegister.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITextFieldDelegate

extension IdPasswordInputViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}


//MARK: - UI Configuration & Initialization

extension IdPasswordInputViewController {

    private func configure() {
        setNavBarBackButtonItemTitle()
        configureTextFields()
        configureButtons()
    }
    
    private func configureTextFields() {
        [idTextField, passwordTextField, checkPasswordTextField].forEach { textField in
            guard let textField = textField else { return }
            textField.borderStyle = .none
            textField.layer.cornerRadius = textField.frame.height / 2
            textField.textAlignment = .center
            textField.adjustsFontSizeToFitWidth = true
            textField.minimumFontSize = 12
            textField.layer.masksToBounds = true
            textField.delegate = self
        }
        
        idTextField.attributedPlaceholder = NSAttributedString(
            string: "아이디 입력",
            attributes: [.foregroundColor: UIColor.white]
        )
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호 입력",
            attributes: [.foregroundColor: UIColor.white]
        )
        checkPasswordTextField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호 재입력",
            attributes: [.foregroundColor: UIColor.white]
        )
    }
    
    private func configureButtons() {
        
        [nextStepButton, nextStepArrow].forEach { button in
            guard let button = button else { return }
            button.addTarget(
                self,
                action: #selector(pressedNextStepButton),
                for: .touchUpInside
            )
            
        }
        nextStepButton.setTitle("다음 단계로 넘어가기", for: .normal)
    }
}
