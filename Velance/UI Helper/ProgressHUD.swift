import Foundation
import ProgressHUD


//MARK: - Progress Bar related methods

func showProgressBar() {
    ProgressHUD.animationType = .horizontalCirclesPulse
    ProgressHUD.colorAnimation = UIColor(named: Colors.appDefaultColor) ?? .systemGray
    ProgressHUD.colorBackground = .clear
    ProgressHUD.colorHUD = .clear
    ProgressHUD.show()
}

func dismissProgressBar() {
    ProgressHUD.dismiss()
}


