import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabView: UIView!
    
    @IBOutlet weak var homeTabButton: UIButton!
    @IBOutlet weak var shoppingTabButton: UIButton!
    
    private var tabVCs: [UIViewController] = []
    private var currentTabButton: UIButton?
    private var currentVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        instantiateVCs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        changeToCommunityVC()
    }
    
    @IBAction func pressedHomeButton(_ sender: UIButton) {
        changeToCommunityVC()
    }
    
    @IBAction func pressedShoppingButton(_ sender: UIButton) {
        changeToShoppingVC()
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
        homeTabButton.setImage(UIImage(named: Images.homeTabBarIcon_unselected), for: .normal)
        homeTabButton.setImage(UIImage(named: Images.homeTabBarIcon_selected), for: .selected)
        homeTabButton.setImage(UIImage(named: Images.homeTabBarIcon_selected), for: .highlighted)
        
        homeTabButton.setTitle("기록", for: .normal)
        homeTabButton.setTitleColor(UIColor(named: Colors.tabBarUnselectedColor), for: .normal)
        homeTabButton.setTitleColor(UIColor(named: Colors.tabBarSelectedColor), for: .selected)
        homeTabButton.setTitleColor(UIColor(named: Colors.tabBarSelectedColor), for: .highlighted)
        homeTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        homeTabButton.alignTextBelow()
        
        shoppingTabButton.setImage(UIImage(named: Images.shopTabBarIcon_unselected), for: .normal)
        shoppingTabButton.setImage(UIImage(named: Images.shopTabBarIcon_selected), for: .selected)
        shoppingTabButton.setImage(UIImage(named: Images.shopTabBarIcon_selected), for: .highlighted)
        
        shoppingTabButton.setTitle("쇼핑", for: .normal)
        shoppingTabButton.setTitleColor(UIColor(named: Colors.tabBarUnselectedColor), for: .normal)
        shoppingTabButton.setTitleColor(UIColor(named: Colors.tabBarSelectedColor), for: .selected)
        shoppingTabButton.setTitleColor(UIColor(named: Colors.tabBarSelectedColor), for: .highlighted)
        shoppingTabButton.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        shoppingTabButton.alignTextBelow()
    }
    
    private func instantiateVCs() {
        let navControllerSettings: (UINavigationController) -> Void = { navController in
            navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            navController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navController.navigationBar.shadowImage = UIImage()
        }
        
        let community = instantiateVC(storyboard: "Community", identifier: "CommunityNavigationController", settings: navControllerSettings)
        let shopping = instantiateVC(storyboard: "Shopping", identifier: "ShoppingNavigationController", settings: navControllerSettings)
        
        tabVCs = [community, shopping]
    }
    
    private func instantiateVC(storyboard: String, identifier: String, settings: (UINavigationController) -> Void) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
//        settings(vc) // navControllerSettings가 필요하면 쓰고 안그러면 나중에 삭제하기
        addChild(vc)
        vc.didMove(toParent: self)
        
        return vc
    }

    private func changeToCommunityVC() {
        currentTabButton?.isSelected = false
        currentTabButton = homeTabButton
        currentTabButton?.isSelected = true
        
        currentVC?.remove()
        let vc = tabVCs[0]
        add(vc, frame: containerView.frame)
        currentVC = vc
    }
    
    private func changeToShoppingVC() {
        currentTabButton?.isSelected = false
        currentTabButton = shoppingTabButton
        currentTabButton?.isSelected = true
        
        currentVC?.remove()
        let vc = tabVCs[1]
        add(vc, frame: containerView.frame)
        currentVC = vc
    }
}
