import UIKit

class ProductReviewViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var topImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dragIndicator: UIView!
    @IBOutlet weak var reviewTableView: UITableView!
       

    
    //MARK: - Constants

    fileprivate struct Metrics {
        
        static let topImageViewMaxHeight: CGFloat = 300
        static let topImageViewMinHeight: CGFloat = 100
        static var startingTopImageViewHeight: CGFloat = topImageViewMaxHeight
    }
    
    
    static var storyboardName: String {
        StoryboardName.productReview
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

    }
    


}

//MARK: - IBActions & Target Methods

extension ProductReviewViewController {
    
}



//MARK: - UITableViewDelegate, UITableViewDataSource

extension ProductReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellID.productReviewTVC,
            for: indexPath
        ) as? ProductReviewTableViewCell else { return ProductReviewTableViewCell() }
        

        
        
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        topImageViewHeight.constant = Metrics.topImageViewMinHeight
        
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= 0 {

            topImageViewHeight.constant = Metrics.topImageViewMaxHeight
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
    }
}

//MARK: - UIPanGestureRecognizer Methods

extension ProductReviewViewController {
    
    private func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) }) else { return number }
        return nearestVal
    }
    
    private func changeTopImageViewHeight(to height: CGFloat, option: UIView.AnimationOptions) {
        topImageViewHeight.constant = height
        
        UIView.animate(withDuration: 0.2, delay: 0, options: option, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self.view)
        let velocity = panGestureRecognizer.velocity(in: self.view)
        
        switch panGestureRecognizer.state {
        case .began:
            Metrics.startingTopImageViewHeight = topImageViewHeight.constant
        case .changed:
            let modifiedTopClearViewHeight = Metrics.startingTopImageViewHeight + translation.y
            if modifiedTopClearViewHeight > Metrics.topImageViewMinHeight && modifiedTopClearViewHeight < Metrics.topImageViewMaxHeight {
                topImageViewHeight.constant = modifiedTopClearViewHeight
            }
        case .ended:
            if velocity.y > 1500 {
                changeTopImageViewHeight(to: Metrics.topImageViewMaxHeight, option: .curveEaseOut)
            } else if velocity.y < -1500 {
                changeTopImageViewHeight(to: Metrics.topImageViewMinHeight, option: .curveEaseOut)
            } else {
                let nearestVal = nearest(to: topImageViewHeight.constant, inValues: [Metrics.topImageViewMaxHeight, Metrics.topImageViewMinHeight])
                changeTopImageViewHeight(to: nearestVal, option: .curveEaseIn)
            }
        default:
            break
        }
    }
    
}


//MARK: - UI Configuration & Initialization

extension ProductReviewViewController {
    
    private func configure() {
        configureDragIndicator()
        configurePanGestureRecognizer()
        configureTableView()
    }
    
    private func configureDragIndicator() {
        dragIndicator.layer.cornerRadius = dragIndicator.frame.height / 2
    }
    
    private func configurePanGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(viewPanned(_:))
        )
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    private func configureTableView() {
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 120))
        
        
        
        headerView.backgroundColor = .orange

        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(viewPanned(_:))
        )
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        headerView.addGestureRecognizer(panGesture)
        
        reviewTableView.tableHeaderView = headerView
        
        
        let reviewTableViewCell = UINib(
            nibName: XIB_ID.productReviewTVC,
            bundle: nil
        )
        
        reviewTableView.register(
            reviewTableViewCell,
            forCellReuseIdentifier: CellID.productReviewTVC
        )

        reviewTableView.rowHeight = UITableView.automaticDimension
        reviewTableView.estimatedRowHeight = 350
    }
    
    
}
