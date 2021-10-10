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
        
    }
    
    @IBAction func pressedRegisterButton(_ sender: UIButton) {
        
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
