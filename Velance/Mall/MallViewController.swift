import UIKit
import ImageSlideshow
import SDWebImage
import SnapKit

class MallViewController: UIViewController, Storyboarded {

    @IBOutlet var mallThumbnailImageView: UIImageView!
    @IBOutlet var topImageViewHeight: NSLayoutConstraint!
    @IBOutlet var bottomView: VLBottomView!
    @IBOutlet var dragIndicator: UIView!
    @IBOutlet var menuTableView: UITableView!
    
    var mallId: Int?
    var mallName: String?
    var isVegan: String?
    var mallAddress: String?
    var mallThumbnailUrl: URL?
    
    private let viewModel = MallViewModel()
    
    //MARK: - Constants
    
    fileprivate struct Metrics {
        
        static let topImageViewMaxHeight: CGFloat = 280
        static let topImageViewMinHeight: CGFloat = 100
        static var startingTopImageViewHeight: CGFloat = topImageViewMaxHeight
    }
    
    static var storyboardName: String {
        StoryboardName.mall
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupViewModel()
        bottomView.backgroundColor = .white
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
        viewModel.fetchMenuList()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    func setupViewModel() {
        viewModel.delegate = self
        viewModel.mallId = mallId
        
    }

}

//MARK: - IBActions & Target Methods

extension MallViewController {
    
    // 메뉴 추가 floating button
    @objc private func pressedAddMenuButton() {
        guard let vc = NewMenuViewController.instantiate() as? NewMenuViewController else { return }
        
        if let mallId = mallId {
            vc.mallId = mallId
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 더보기 버튼
    @objc private func pressedOptionsBarButtonItem() {
        
        let reportAction = UIAlertAction(
            title: "신고하기",
            style: .default
        ) { [weak self] _ in self?.presentReportProductActionSheet() }
        let actionSheet = UIHelper.createActionSheet(with: [reportAction], title: nil)
        present(actionSheet, animated: true)
    }
    
    private func presentReportProductActionSheet() {
        
        let incorrectMallAddress = UIAlertAction(
            title: ReportType.Mall.incorrectMallAddress.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.report(reportType: ReportType.Mall.incorrectMallAddress)
        }
        
        let incorrectMallName = UIAlertAction(
            title: ReportType.Mall.incorrectMallName.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.report(reportType: ReportType.Mall.incorrectMallName)
        }
        
        let inappropriatePicture = UIAlertAction(
            title: ReportType.Mall.inappropriatePicture.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.report(reportType: ReportType.Mall.inappropriatePicture)
        }

        
        let actionSheet = UIHelper.createActionSheet(with: [incorrectMallAddress, incorrectMallName, inappropriatePicture], title: "신고 사유 선택")
        present(actionSheet, animated: true)
    }
    
    private func report(reportType: ReportType.Mall) {
        viewModel.reportReview(type: reportType)
    }
}

//MARK: - MallViewModelDelegate

extension MallViewController: MallViewModelDelegate {

    func didFetchMenuList() {
        menuTableView.reloadData()
        menuTableView.tableFooterView = nil
        menuTableView.refreshControl?.endRefreshing()
    }
    
    func failedFetchingMenuList(with error: NetworkError) {
        showSimpleBottomAlert(with: error.errorDescription)
        menuTableView.tableFooterView = nil
        menuTableView.refreshControl?.endRefreshing()
    }
    
    func didLikeMenu(at indexPath: IndexPath) {
        
        viewModel.menuList[indexPath.row].isLike = "Y"
        viewModel.menuList[indexPath.row].likeCount += 1
        menuTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func didCancelLikeMenu(at indexPath: IndexPath) {
        viewModel.menuList[indexPath.row].isLike = nil
        viewModel.menuList[indexPath.row].likeCount -= 1
        menuTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func failedUserRequest(with error: NetworkError) {
        showSimpleBottomAlert(with: error.errorDescription)
    }
    
    func didCompleteReport() {
        showSimpleBottomAlert(with: "신고 처리가 완료됐어요! 벨런스 팀이 검토 후 조치할게요.👍")
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension MallViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewModel.menuList.count == 0 { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MenuTableViewCell",
            for: indexPath
        ) as? MenuTableViewCell else { return MenuTableViewCell() }
        
        let menuData = viewModel.menuList[indexPath.row]
        
        cell.delegate = self
        cell.menuId = menuData.menuId
        cell.indexPath = indexPath
        
        cell.menuImageView.sd_setImage(
            with: URL(string: menuData.fileFolder.files[0].path),
            placeholderImage: UIImage(named: "placeholderImage"),
            options: .continueInBackground
        )
        cell.menuNameLabel.text = menuData.name
        cell.menuCautionLabel.text = "\(menuData.caution ?? "주의사항 별도 등록되지 않음")"
        cell.menuPriceLabel.text = "\(menuData.price)원"
        
        cell.likeButton.setLeftImage(image: UIImage(named: "ThumbLogo")!)
        cell.likeButton.setRightText(text: "\(menuData.likeCount)")
        

        // 특정 메뉴에 대해 "좋아요"를 했을 때만 "Y"가 날라오고 아니면 속성 자체가 안 날라옴
        if let _ = menuData.isLike {
            cell.likeButton.isSelected = true
        } else {
            cell.likeButton.isSelected = false
        }
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
        viewModel.refreshTableView()
    }
}

//MARK: - MallMenusTableViewCellDelegate

extension MallViewController: MenuTableViewCellDelegate {
    
    func didChooseToLikeMenu(menuId: Int, indexPath: IndexPath) {
        viewModel.likeMenu(menuId: menuId, indexPath: indexPath)
    }
    
    func didChooseToCancelLikeMenu(menuId: Int, indexPath: IndexPath) {
        viewModel.cancelLikeMenu(menuId: menuId, indexPath: indexPath)
    }
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
        mallThumbnailImageView.sd_setImage(
            with: mallThumbnailUrl,
            placeholderImage: UIImage(named: "placeholderImage"),
            options: .continueInBackground
        )
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
        
        headerView.configure(mallId: mallId, mallName: mallName, isVegan: isVegan, mallAddress: mallAddress)
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
        addMenuButton.setImage(UIImage(named: "pencilIcon"), for: .normal)
        addMenuButton.addTarget(
            self,
            action: #selector(pressedAddMenuButton),
            for: .touchUpInside
        )
        view.addSubview(addMenuButton)
        addMenuButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.right.equalTo(view.snp.right).offset(-25)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}
