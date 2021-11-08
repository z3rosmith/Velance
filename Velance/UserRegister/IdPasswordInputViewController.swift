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
        
        if !validateUserInput() { return }
        
        UserRegisterValues.shared.username = idTextField.text!
        UserRegisterValues.shared.displayName = idTextField.text!
        UserRegisterValues.shared.password = passwordTextField.text!
        
        guard let vc = InputUserInfoForRegisterViewController.instantiate() as? InputUserInfoForRegisterViewController else { return }
        vc.isForEditingUser = false
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: Colors.appDefaultColor)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func validateUserInput() -> Bool {
        guard
            let id = idTextField.text,
            let pw = passwordTextField.text,
            let checkPw = checkPasswordTextField.text else {
                showSimpleBottomAlert(with: "빈 칸이 없는지 확인해주세요.")
                return false
            }
        
        if id.count < 5 || id.count > 15 {
            showSimpleBottomAlert(with: "아이디는 5자 이상, 15자 이하로 설정해주세요.")
            return false
        }
    
        if pw.count < 5 || pw.count > 15 {
            showSimpleBottomAlert(with: "비밀번호는 5자 이상, 15자 이하로 설정해주세요.")
            return false
        }
    
        if pw != checkPw {
            showSimpleBottomAlert(with: "비밀번호가 일치하지 않아요.")
            return false
        }
        return true
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
        
        passwordTextField.isSecureTextEntry = true
        checkPasswordTextField.isSecureTextEntry = true
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
