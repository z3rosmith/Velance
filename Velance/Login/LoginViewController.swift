import UIKit

class LoginViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    static var storyboardName: String {
        StoryboardName.login
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    

}

//MARK: - IBActions

extension LoginViewController {
    
    @IBAction func pressedLoginButton(_ sender: UIButton) {
        
        guard let id = idTextField.text, let pw = passwordTextField.text else {
            return
        }
        showProgressBar()
        UserManager.shared.login(
            username: id,
            password: pw
        ) { [weak self] result in
            guard let self = self else { return }
            dismissProgressBar()
            switch result {
            case .success:
                print("✏️ 로그인 성공!")
                self.navigateToHome()
            case .failure(_):
                self.presentVLAlert(
                    title: "로그인 실패",
                    message: "아이디랑 비밀번호를 다시 한 번 확인해주세요 🤔",
                    buttonTitle: "확인"
                )
            }
        }
        
    }
    
    @IBAction func pressedRegisterButton(_ sender: UIButton) {
        let vc = IdPasswordInputViewController.instantiate()
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}

//MARK: - Initialization & UI Configuration

extension LoginViewController {
    
    private func configure() {
        configureTextFields()
        configureButtons()
    }
    
    private func configureTextFields() {
        [idTextField, passwordTextField].forEach { textField in
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
    }
    
    private func configureButtons() {
        
        [loginButton, registerButton].forEach { button in
            guard let button = button else { return }
            button.layer.cornerRadius = button.frame.height / 2
            button.addBounceAnimationWithNoFeedback()
        }
    }
    
}
