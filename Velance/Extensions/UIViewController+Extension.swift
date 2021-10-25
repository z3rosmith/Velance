import UIKit
import SnackBar_swift

extension UIViewController {
    
    func add(_ child: UIViewController, frame: CGRect) {
        child.view.frame = frame
        view.addSubview(child.view)
    }
    
    func remove() {
        view.removeFromSuperview()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func presentVLAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = AlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}

//MARK: - Navigation Bar Related

extension UIViewController {
    
    // Navigation Bar 뒤로가기 버튼 그냥 화살표 설정 또는 타이틀 별도 지정 가능
    func setNavBarBackButtonItemTitle(to title: String = "") {
        let backBarButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func setClearNavigationBarBackground() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setNavigationBarAppearance(to color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
}

extension UIViewController {
    
    // 가장 기본적인 Alert 띄우기
    func presentSimpleAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "확인",
            style: .default
        )
        alertController.addAction(okAction)
        alertController.view.tintColor = .black
        present(alertController, animated: true)
    }
    
    // 확인 버튼을 누를 수 있는 Alert 띄우기
    func presentAlertWithConfirmAction(title: String, message: String, completion: @escaping ((Bool) -> Void)) {
        
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "확인",
            style: .default
        ) { pressedOk in
            completion(true)
        }
        let cancelAction = UIAlertAction(
            title: "취소",
            style: .cancel
        ) { pressedCancel in
            completion(false)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        alertController.view.tintColor = .black
        present(alertController, animated: true, completion: nil)
    }
    
    // SnackBar 라이브러리의 message 띄우기
    func showSimpleBottomAlert(with message: String) {
        SnackBar.make(in: self.view,
                      message: message,
                      duration: .lengthLong).show()
    }
    
    // SnackBar 라이브러리의 액션이 추가된 message 띄우기
    func showSimpleBottomAlertWithAction(message: String,
                                         buttonTitle: String,
                                         action: (() -> Void)? = nil) {
        SnackBar.make(in: self.view,
                      message: message,
                      duration: .lengthLong).setAction(
                        with: buttonTitle,
                        action: {
                            action?()
                        }).show()

    }
}

//MARK: - Navigation / Router

extension UIViewController {
    
    #warning("아래 수정 필요 -> 홈화면으로 가야함")
    func navigateToHome() {
        let vc = ProductReviewListContainerViewController.instantiate()
        let navController = UINavigationController(rootViewController: vc)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(navController)
    }
}
