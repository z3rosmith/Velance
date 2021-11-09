import UIKit
import ImageSlideshow
import SDWebImage
import SnapKit

class ProductReviewViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var productThumbnailImageView: UIImageView!
    @IBOutlet weak var topImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dragIndicator: UIView!
    @IBOutlet weak var reviewTableView: UITableView!
    
    var productId: Int?
    var productThumbnailUrl: URL?
    var productName: String?
    var rating: Int?
    var price: Int?
    var productAllergyGroup: [ProductAllergyGroups]?
    
    private var viewModel: ProductReviewViewModel?
    //MARK: - Constants
    
    fileprivate struct Metrics {
        
        static let topImageViewMaxHeight: CGFloat = 320
        static let topImageViewMinHeight: CGFloat = 100
        static var startingTopImageViewHeight: CGFloat = topImageViewMaxHeight
    }
    
    
    static var storyboardName: String {
        StoryboardName.productReview
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewModel()
        configure()
        bottomView.backgroundColor = .white
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
        viewModel?.fetchReviewList()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    func setUpViewModel() {
        viewModel = ProductReviewViewModel(
            productManager: ProductManager(),
            reportManager: ReportManager(),
            productId: productId ?? 1
        )
        viewModel?.delegate = self
    }
}

//MARK: - IBActions & Target Methods

extension ProductReviewViewController {
    
    @objc private func pressedOptionsBarButtonItem() {
        
        let reportAction = UIAlertAction(
            title: "신고하기",
            style: .default
        ) { [weak self] _ in self?.presentReportProductActionSheet() }
        let actionSheet = UIHelper.createActionSheet(with: [reportAction], title: nil)
        present(actionSheet, animated: true)
    }
    
    private func presentReportProductActionSheet() {
        
        let incorrectProductPicture = UIAlertAction(
            title: ReportType.Product.incorrectProductPicture.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.report(reportType: ReportType.Product.incorrectProductPicture)
        }
        
        let inappropriateProductPicture = UIAlertAction(
            title: ReportType.Product.inappropriateProductPicture.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.report(reportType: ReportType.Product.inappropriateProductPicture)
        }
        
        let incorrectPrice = UIAlertAction(
            title: ReportType.Product.incorrectPrice.rawValue,
            style: .default
        ) { [weak self] _ in
            self?.report(reportType: ReportType.Product.incorrectPrice)
        }
        let actionSheet = UIHelper.createActionSheet(with: [incorrectProductPicture, inappropriateProductPicture, incorrectPrice], title: "신고 사유 선택")
        present(actionSheet, animated: true)
    }
    
    private func report(reportType: ReportType.Product) {
        viewModel?.reportProduct(type: reportType)
    }
    
    @objc private func pressedAddReviewButton() {
        guard let vc = NewProductReviewViewController.instantiate() as? NewProductReviewViewController else { return }
        vc.productId = productId ?? 0
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - ProductReviewDelegate

extension ProductReviewViewController: ProductReviewDelegate {
    
    func didFetchReviewList() {
        reviewTableView.reloadData()
        reviewTableView.tableFooterView = nil
        reviewTableView.refreshControl?.endRefreshing()
    }
    
    func failedFetchingReviewList(with error: NetworkError) {
        showSimpleBottomAlert(with: error.errorDescription)
        reviewTableView.tableFooterView = nil
        reviewTableView.refreshControl?.endRefreshing()
    }
    
    func didCompleteReport() {
        showSimpleBottomAlert(with: "신고 처리가 완료됐어요! 벨런스 팀이 검토 후 조치할게요.👍")
    }
    
    func didBlockUser() {
        showSimpleBottomAlert(with: "해당 사용자를 차단했어요.")
        reviewTableView.reloadData()
    }
    
    func didDeleteReview() {
        showSimpleBottomAlert(with: "리뷰를 삭제했어요.")
        reviewTableView.reloadData()
    }
    
    func failedUserRequest(with error: NetworkError) {
        showSimpleBottomAlert(with: error.errorDescription)
    }
    
    
}

//MARK: - ProductReviewTableViewCellDelegate

extension ProductReviewViewController: ProductReviewTableViewCellDelegate {

    
    func didChooseToReportUser(type: ReportType.Review, reviewId: Int) {
        viewModel?.reportReview(type: type, reviewId: reviewId)
    }
    
    func didChooseToBlockUser(userId: String) {
        viewModel?.blockUser(targetUserId: userId)
    }
    
    func didChooseToDeleteMyReview(reviewId: Int) {
        viewModel?.deleteMyReview(reviewId: reviewId)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ProductReviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.reviewList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellID.productReviewTVC,
            for: indexPath
        ) as? ProductReviewTableViewCell else { return ProductReviewTableViewCell() }
        
        guard let reviewData = viewModel?.reviewList[indexPath.row] else {
            return ProductReviewTableViewCell()
        }
        
        cell.currentVC = self
        cell.delegate = self
        
        cell.reviewId = reviewData.reviewId
        cell.createdBy = reviewData.user.userUid
        cell.reviewLabel.text = reviewData.contents
        cell.ratingView.setStarsRating(rating: reviewData.rating)
        cell.nicknameLabel.text = reviewData.user.displayName
        
        cell.profileImageView.sd_setImage(
            with: URL(string: reviewData.user.fileFolder?.files[0].path ?? ""),
            placeholderImage: UIImage(named: "avatarImage"),
            options: .continueInBackground
        )

        var imageSources: [InputSource] = []
        for file in reviewData.fileFolder.files {
            imageSources.append(SDWebImageSource(url: URL(string: file.path)!))
        }
        cell.reviewImageSlideShow.setImageInputs(imageSources)

        cell.dateLabel.text = reviewData.formattedDate
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
    
        if position > (reviewTableView.contentSize.height - 20 - scrollView.frame.size.height) {
            guard let viewModel = viewModel else { return }
            if !viewModel.isFetchingData {
                reviewTableView.tableFooterView = UIHelper.createSpinnerFooterView(in: view)
                viewModel.fetchReviewList()
            }
        }
    }
    
    @objc private func refreshReviewTableView() {
        viewModel?.refreshTableView()
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
        configureProductThumbnailImageView()
        configureDragIndicator()
        configurePanGestureRecognizer()
        configureTableView()
        addOptionsBarButtonItem()
        addFloatingButton()

    }
    
    private func configureProductThumbnailImageView() {
        productThumbnailImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        productThumbnailImageView.sd_setImage(
            with: productThumbnailUrl,
            placeholderImage: UIImage(named: "imagePlaceholder"),
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
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        reviewTableView.separatorStyle = .none
        reviewTableView.allowsSelection = false
        
        let headerView = ProductReviewHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 250))
        
        headerView.configure(
            productName: self.productName ?? "로딩 중..",
            rating: self.rating ?? 0,
            price: self.price ?? 0,
            productAllergyGroup: productAllergyGroup
        )

        reviewTableView.tableHeaderView = headerView
        let reviewTableViewCell = UINib(
            nibName: XIB_ID.productReviewTVC,
            bundle: nil
        )
        
        reviewTableView.register(
            reviewTableViewCell,
            forCellReuseIdentifier: CellID.productReviewTVC
        )
        
        reviewTableView.refreshControl = UIRefreshControl()
        reviewTableView.refreshControl?.addTarget(
            self,
            action: #selector(refreshReviewTableView),
            for: .valueChanged
        )
        
        reviewTableView.rowHeight = UITableView.automaticDimension
        reviewTableView.estimatedRowHeight = 450
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
        let addReviewButton = VLFloatingButton()
        addReviewButton.setImage(UIImage(named: "pencilIcon"), for: .normal)
//        addReviewButton.setImage(UIImage(systemName: "pencil")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        addReviewButton.addTarget(
            self,
            action: #selector(pressedAddReviewButton),
            for: .touchUpInside
        )
        view.addSubview(addReviewButton)
        addReviewButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.right.equalTo(view.snp.right).offset(-25)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }
    }
    
}
