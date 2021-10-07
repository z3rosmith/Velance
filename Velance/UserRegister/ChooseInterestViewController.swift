import UIKit

class ChooseInterestViewController: UIViewController, Storyboarded {
    
    static var storyboardName: String {
        StoryboardName.userRegister
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    


}

//MARK: - UI Configuration & Initialization

extension ChooseInterestViewController {
    
    private func configure() {
        title = "회원가입"
    }
    
    
}
