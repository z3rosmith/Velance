import UIKit
import Gifu
import SnapKit

class LoadingViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var animatedLoadingImageView: GIFImageView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    private let labelFont: UIFont = .systemFont(ofSize: 20)
    
    static var storyboardName: String {
        StoryboardName.userRegister
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerUser()
        
        
        animatedLoadingImageView.animate(withGIFNamed: "LoadingAnimation")

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
                DispatchQueue.main.async {
                    self.presentVLAlert(title: "성공!", message: "회원가입에 성공했어요!", buttonTitle: "확인")
                }
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
        
        
    }


}
