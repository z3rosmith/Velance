import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topClearViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var dragIndicator: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    private let maxTopClearViewHeight: CGFloat = 250
    private let minTopClearViewHeight: CGFloat = 10
    private lazy var startingTopClearViewHeight: CGFloat = self.maxTopClearViewHeight
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupUI()
        setupGestureRecognizer()
    }
    
//    @IBAction func tap(_ sender: Any) {
//        self.bottomViewHeight.constant = 600
//        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else { return }
//        vc.modalPresentationStyle = .overFullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        vc.bottomHeight = self.bottomViewHeight.constant + LayoutConstants.tabContainerViewHeight
//
//        UIView.animate(withDuration: 0.2) {
//            self.view.layoutIfNeeded()
//        } completion: { _ in
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
}

extension HomeViewController {
    
    private func setupUI() {
        configureBottomView()
        configureLeftRightButtons()
        configureDragIndicator()
    }
    
    private func configureBottomView() {
        bottomView.layer.cornerRadius = 30
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func configureLeftRightButtons() {
        leftButton.setTitleColor(#colorLiteral(red: 0.1568627451, green: 0.2784313725, blue: 0, alpha: 1), for: .selected)
        rightButton.setTitleColor(#colorLiteral(red: 0.1568627451, green: 0.2784313725, blue: 0, alpha: 1), for: .selected)
    }
    
    private func configureDragIndicator() {
        dragIndicator.layer.cornerRadius = dragIndicator.frame.height / 2
    }
    
    private func setupScrollView() {
        scrollView.isScrollEnabled = false
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupGestureRecognizer() {
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
    }
    
    private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) }) else { return number }
        return nearestVal
    }
    
    private func changeHeightClearView(to height: CGFloat, option: UIView.AnimationOptions) {
        topClearViewHeight.constant = height
        
        UIView.animate(withDuration: 0.2, delay: 0, options: option, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self.view)
        let velocity = panGestureRecognizer.velocity(in: self.view)
        
        switch panGestureRecognizer.state {
        case .began:
            startingTopClearViewHeight = topClearViewHeight.constant
        case .changed:
            let modifiedTopClearViewHeight = startingTopClearViewHeight + translation.y
            if modifiedTopClearViewHeight > minTopClearViewHeight && modifiedTopClearViewHeight < maxTopClearViewHeight {
                topClearViewHeight.constant = modifiedTopClearViewHeight
            }
        case .ended:
            if velocity.y > 1500 {
                changeHeightClearView(to: maxTopClearViewHeight, option: .curveEaseOut)
            } else if velocity.y < -1500 {
                changeHeightClearView(to: minTopClearViewHeight, option: .curveEaseOut)
            } else {
                let nearestVal = nearest(to: topClearViewHeight.constant, inValues: [maxTopClearViewHeight, minTopClearViewHeight])
                changeHeightClearView(to: nearestVal, option: .curveEaseIn)
            }
        default:
            break
        }
    }
}
