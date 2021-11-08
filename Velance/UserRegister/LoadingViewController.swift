import UIKit
import Lottie

class LoadingViewController: UIViewController, Storyboarded {
    
    @IBOutlet var animationView: AnimationView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    private let labelFont: UIFont = .systemFont(ofSize: 20)
    
    static var storyboardName: String {
        StoryboardName.userRegister
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarBackButtonItemTitle(to: "")
        configureUI()

        animationView.animation = Animation.named("loadingAnimation")
        
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        
        registerUser()
    }
    
    func configureUI() {
        loadingLabel.attributedText = NSMutableAttributedString()
            .normal("당신에게 ", with: labelFont)
            .bold("딱 필요한\n비건 서비스를 ", with: .systemFont(ofSize: 23, weight: .bold))
            .normal("제작 중입니다...", with: labelFont)
    }
    
    func registerUser() {
        
        let model = UserRegisterDTO(
            username:           UserRegisterValues.shared.username,
            displayName:        UserRegisterValues.shared.displayName,
            password:           UserRegisterValues.shared.password,
            vegetarianTypeId:   UserRegisterValues.shared.vegetarianTypeId,
            tasteTypeIds:       UserRegisterValues.shared.tasteTypeIds,
            interestTypeIds:    UserRegisterValues.shared.interestTypeIds,
            allergyTypeIds:     UserRegisterValues.shared.allergyTypeIds
        )
        
        UserManager.shared.register(with: model) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print("✏️ 회원 가입 성공!")
                self.login()
            case .failure(let error):
                let message = error == .internalError
                ? "중복된 아이디입니다. 뒤로 가서 다시 설정해주세요."
                : "알 수 없는 오류가 발생했어요. 잠시 후 다시 시도해주세요."
                self.presentVLAlert(
                    title: "오류",
                    message: message,
                    buttonTitle: "확인"
                )
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        
    }
    
    func login() {
        
        UserManager.shared.login(
            username: UserRegisterValues.shared.username,
            password: UserRegisterValues.shared.password
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print("✏️ 로그인 성공")
                self.presentHomeVC()
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
        
    }
    
    func presentHomeVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let storyboard = UIStoryboard(name: StoryboardName.main, bundle: nil)
            guard let vc = storyboard.instantiateViewController(
                withIdentifier: "MainViewController"
            ) as? MainViewController else { return  }
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        }
    }
    
    
}
