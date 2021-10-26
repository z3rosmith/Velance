import UIKit
import IQKeyboardManagerSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        guard let window = window else { return }
        window.tintColor = .black
        window.rootViewController = User.shared.isLoggedIn ? createHomeScreenVC() : createLoginScreenVC()
        configureIQKeyboardManager()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

//MARK: - Router

extension SceneDelegate {
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else { return }
        window.rootViewController = vc
    }
    
    // 로그인 되어 있을 시
    func createHomeScreenVC() -> UIViewController {
        #warning("추후 수정 필요 -> 피드 화면으로 가야함 (커뮤니티 탭")
        let vc = ProductReviewListContainerViewController.instantiate()
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.tintColor = .black
        return navController
    }
    
    
    // 로그인이 안 되어 있을 시
    func createLoginScreenVC() -> UIViewController {
        let vc = LoginViewController.instantiate()
        let navController = UINavigationController(rootViewController: vc)
        return navController
    }
    
}

extension SceneDelegate {

    func configureIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}
