import UIKit
import Gifu

class LoadingViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var animatedLoadingImageView: GIFImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    private let labelFont: UIFont = .systemFont(ofSize: 20)
    
    static var storyboardName: String {
        StoryboardName.userRegister
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarBackButtonItemTitle(to: "")
        configureUI()
        animatedLoadingImageView.animate(withGIFNamed: "LoadingAnimation")
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
                self.showSimpleBottomAlert(with: error.errorDescription)
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
                #warning("여기서 navigate 해야함")
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
        
    }
    
    #warning("아래 수정 필요 -> 홈화면으로 가야함")
    func presentHomeVC() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let vc = ProductReviewListContainerViewController.instantiate()
            let navController = UINavigationController(rootViewController: vc)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navController)
        }

    }
    
    
}
