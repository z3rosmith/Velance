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
