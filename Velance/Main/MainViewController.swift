import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var tabStackView: UIStackView!
    
    private var tabVCs: [UIViewController] = []
    private var currentTabButton: UIButton?
    private weak var currentVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        instantiateVCs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFirstVC(index: 0)
    }
}

//MARK: - UI Configuration

extension MainViewController {
    
    private func configure() {
        configureTabView()
        configureTabButtons()
    }
    
    private func configureTabView() {
        tabView.layer.cornerRadius = tabView.frame.height / 2
        tabView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func configureTabButtons() {
        
        for (index, subview) in tabStackView.subviews.enumerated() {
            let button = subview as! UIButton
            
            button.tag = index
            button.setImage(UIImage(named: Images.tabImageInactive[index]), for: .normal)
            button.setImage(UIImage(named: Images.tabImageActive[index]), for: .selected)
            button.setImage(UIImage(named: Images.tabImageActive[index]), for: .highlighted)
            button.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    private func instantiateVCs() {
        let navControllerSettings: (UINavigationController) -> Void = { navController in
            navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navController.navigationBar.shadowImage = UIImage()
        }
        
        let community = instantiateVC(storyboard: "Community", identifier: "CommunityNavigationController", settings: navControllerSettings)
        let mall = instantiateVC(storyboard: "Mall", identifier: "MallNavigationController", settings: navControllerSettings)
        let product = instantiateVC(storyboard: "ProductReview", identifier: "ProductReviewNavigationController", settings: navControllerSettings)
        let mypage = instantiateVC(storyboard: "MyPage", identifier: "MyPageNavigationController", settings: navControllerSettings)
        
        tabVCs = [community, mall, product, mypage]
    }
    
    private func instantiateVC(storyboard: String, identifier: String, settings: (UINavigationController) -> Void) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
//        settings(vc) // navControllerSettings가 필요하면 쓰고 안그러면 나중에 삭제하기
        addChild(vc)
        vc.didMove(toParent: self)
        
        return vc
    }
    
    private func setupFirstVC(index: Int) {
        currentTabButton = tabStackView.subviews[index] as? UIButton
        currentTabButton?.isSelected = true
        
        let vc = tabVCs[index]
        add(vc, frame: containerView.frame)
        currentVC = vc
    }
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        currentTabButton?.isSelected = false
        currentTabButton = tabStackView.subviews[sender.tag] as? UIButton
        currentTabButton?.isSelected = true
        
        currentVC?.remove()
        let vc = tabVCs[sender.tag]
        add(vc, frame: containerView.frame)
        currentVC = vc
    }
}
