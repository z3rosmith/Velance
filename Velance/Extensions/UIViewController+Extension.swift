import UIKit

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
