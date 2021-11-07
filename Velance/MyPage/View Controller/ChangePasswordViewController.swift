import UIKit

class ChangePasswordViewController: UIViewController, Storyboarded {

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var checkPasswordTextField: UITextField!
    
    static var storyboardName: String {
        StoryboardName.myPage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}

//MARK: - Target Methods

extension ChangePasswordViewController {
    
    @IBAction func pressedChangePWButton(_ sender: UIButton) {
        
        if !validateUserInput() { return }
        showProgressBar()
        UserManager.shared.updateUserPassword(password: passwordTextField.text!) { [weak self] result in
            dismissProgressBar()
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.showSimpleBottomAlert(with: "비밀번호 변경 성공 🎉")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
    }
    
    
    private func validateUserInput() -> Bool {
        guard
            let pw = passwordTextField.text,
            let checkPw = checkPasswordTextField.text else {
                showSimpleBottomAlert(with: "빈 칸이 없는지 확인해주세요.")
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

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}


//MARK: - UI Configuration & Initialization

extension ChangePasswordViewController {
    
    private func configure() {
        configureTextFields()
    }
    
    private func configureTextFields() {
        
        [passwordTextField, checkPasswordTextField].forEach { textField in
            guard let textField = textField else { return }
            textField.borderStyle = .none
            textField.layer.cornerRadius = textField.frame.height / 2
            textField.textAlignment = .center
            textField.adjustsFontSizeToFitWidth = true
            textField.minimumFontSize = 12
            textField.layer.masksToBounds = true
            textField.delegate = self
        }
        
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
    
}
