import UIKit
import ImageSlideshow
import SDWebImage
import SnapKit


class MallViewController: UIViewController {

    @IBOutlet var mallThumbnailImageView: UIImageView!
    @IBOutlet var topImageViewHeight: NSLayoutConstraint!
    @IBOutlet var bottomView: VLBottomView!
    @IBOutlet var dragIndicator: UIView!
    @IBOutlet var menuTableView: UITableView!
    
    //MARK: - Constants
    
    fileprivate struct Metrics {
        
        static let topImageViewMaxHeight: CGFloat = 280
        static let topImageViewMinHeight: CGFloat = 100
        static var startingTopImageViewHeight: CGFloat = topImageViewMaxHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configure()
        bottomView.backgroundColor = .white
    }
    
    func setupViewModel() {
        
    }
    


}

//MARK: - IBActions & Target Methods

extension MallViewController {
    
    // 메뉴 추가 floating button
    @objc private func pressedAddMenuButton() {
        let vc = NewMenuViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 더보기 버튼
    @objc private func pressedOptionsBarButtonItem() {

    }
}

//MARK: - MallDelegate

extension MallViewController {
    
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension MallViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MenuTableViewCell",
            for: indexPath
        ) as? MenuTableViewCell else { return MenuTableViewCell() }
        
//        guard let reviewData = viewModel?.reviewList[indexPath.row] else {
//            return ProductReviewTableViewCell()
//        }
        
        cell.menuImageView.image = UIImage(named: "image_test")
        cell.menuNameLabel.text = "비건비건비건"
        cell.menuCautionLabel.text = "주의: 새우가 포함되어있어요!"
        cell.menuPriceLabel.text = "10000원"
        
//        cell.currentVC = self
//        cell.delegate = self
//        cell.reviewLabel.text = reviewData.contents
//        cell.ratingView.setStarsRating(rating: reviewData.rating)
//        cell.nicknameLabel.text = reviewData.user.displayName
//
//        cell.profileImageView.sd_setImage(
//            with: URL(string: reviewData.user.fileFolder?.files[0].path ?? ""),
//            placeholderImage: UIImage(systemName: "person"),
//            options: .continueInBackground
//        )
//
//        var imageSources: [InputSource] = []
//        for file in reviewData.fileFolder.files {
//            imageSources.append(SDWebImageSource(url: URL(string: file.path)!))
//        }
//        cell.reviewImageSlideShow.setImageInputs(imageSources)
//
//        cell.dateLabel.text = reviewData.formattedDate
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        topImageViewHeight.constant = Metrics.topImageViewMinHeight
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        
        if position <= 10 {
            topImageViewHeight.constant = Metrics.topImageViewMaxHeight
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            })
        }
//
//        if position > (menuTableView.contentSize.height - 20 - scrollView.frame.size.height) {
//            guard let viewModel = viewModel else { return }
//            if !viewModel.isFetchingData {
//                menuTableView.tableFooterView = UIHelper.createSpinnerFooterView(in: view)
//                viewModel.fetchReviewList()
//            }
//        }
    }
    
    
    @objc private func refreshMenuTableView() {
//        viewModel?.refreshTableView()
    }
    
    
}


//MARK: - MallMenusTableViewCellDelegate

extension MallViewController {
    
}

//MARK: - UIPanGestureRecognizer Methods

extension MallViewController {
    
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

extension MallViewController {
    
    private func configure() {
        configureMallThumbnailImageView()
        configureDragIndicator()
        configurePanGestureRecognizer()
        configureTableView()
        addOptionsBarButtonItem()
        addFloatingButton()

    }
    
    private func configureMallThumbnailImageView() {
        mallThumbnailImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        mallThumbnailImageView.image = UIImage(named: "image_test")
        #warning("수정 필요 - 이전 목록에서 url 을 가져오고 세팅해야함")
//        mallThumbnailImageView.sd_setImage(
//            with: productThumbnailUrl,
//            placeholderImage: nil,
//            options: .continueInBackground
//        )
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
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.separatorStyle = .none
        menuTableView.allowsSelection = false
        
        let headerView = MallHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 140))
        headerView.configure()
        menuTableView.tableHeaderView = headerView
        
        let menuTableViewCell = UINib(
            nibName: "MenuTableViewCell",
            bundle: nil
        )
        
        menuTableView.register(
            menuTableViewCell,
            forCellReuseIdentifier: "MenuTableViewCell"
        )
        
        menuTableView.refreshControl = UIRefreshControl()
        menuTableView.refreshControl?.addTarget(
            self,
            action: #selector(refreshMenuTableView),
            for: .valueChanged
        )
        
    
    }
    
    private func addOptionsBarButtonItem() {
        let optionsBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(pressedOptionsBarButtonItem)
        )
        navigationItem.rightBarButtonItem = optionsBarButtonItem
    }
    
    private func addFloatingButton() {
        let addMenuButton = VLFloatingButton()
        addMenuButton.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        addMenuButton.addTarget(
            self,
            action: #selector(pressedAddMenuButton),
            for: .touchUpInside
        )
        view.addSubview(addMenuButton)
        addMenuButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.right.equalTo(view.snp.right).offset(-25)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-35)
        }
    }
}
