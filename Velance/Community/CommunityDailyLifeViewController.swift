import UIKit
import ImageSlideshow

class CommunityDailyLifeViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    private let viewModel = CommunityDailyLifeListViewModel()
    
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    private let headerReuseIdentifier = "CommunityCollectionReusableView1"
    private let cellReuseIdentifier = "CommunityFeedCollectionViewCell"
    
    private var cellHeights: [CGFloat] = []
    private let basicCellHeight: CGFloat = 575
    
    private var interestOptions: [Int] = []
    private var regionOptions: [String] = []
    private var viewOnlyFollowing: Bool = false
    
    private weak var chooseInterestButton: UIButton?
    private weak var chooseRegionButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        addFloatingButton()
        viewModel.delegate = self
        viewModel.fetchPostList(interestTypeIDs: nil, regionIds: nil, viewOnlyFollowing: viewOnlyFollowing)
    }
}

extension CommunityDailyLifeViewController {
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CommunityFeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self,
                                                 action: #selector(didDragCollectionView), for: .valueChanged)
    }
    
    /// dynamic collection view cell height를 위해서 basicCellHeight를 numberOfItems 개수만큼 저장함
    private func setCellHeightsArray(numberOfItems: Int) {
        cellHeights = Array<CGFloat>(repeating: basicCellHeight, count: numberOfItems)
    }
    
    @objc private func didDragCollectionView() {
        viewModel.refreshPostList(interestTypeIDs: interestOptions, regionIds: regionOptions, viewOnlyFollowing: viewOnlyFollowing)
    }
    
    @objc private func didLikeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc private func didTapCommentButton(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CommunityDetailViewController") as? CommunityDetailViewController else { return }
        nextVC.isRecipe = false
        nextVC.id = sender.tag
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func textViewTapped(gestureRecognizer: UIGestureRecognizer) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CommunityDetailViewController") as? CommunityDetailViewController else { return }
        nextVC.isRecipe = false
        nextVC.id = gestureRecognizer.view!.tag
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func addFloatingButton() {
        let addReviewButton = VLFloatingButton()
        addReviewButton.setImage(UIImage(named: "pencilIcon"), for: .normal)
        addReviewButton.addTarget(
            self,
            action: #selector(pressedAddPostButton),
            for: .touchUpInside
        )
        view.addSubview(addReviewButton)
        addReviewButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.right.equalTo(view.snp.right).offset(-25)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }
    }
    
    @objc private func pressedAddPostButton() {
        let vc = NewDailyLifePostViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CommunityDailyLifeViewController: UICollectionViewDelegate {
    
}

extension CommunityDailyLifeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? CommunityCollectionReusableView1 else { fatalError() }
            chooseInterestButton = headerView.chooseInterestsButton
            chooseRegionButton = headerView.chooseRegionButton
            headerView.chooseInterestsButton.isHidden = false
            headerView.categoryCollectionView.isHidden = true
            headerView.delegate = self
            return headerView
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfPosts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? CommunityFeedCollectionViewCell else { fatalError() }
        if viewModel.numberOfPosts == 0 { return cell }
        let cellViewModel = viewModel.postAtIndex(indexPath.item)
        
        // MARK: - configure cell(data)
        cell.userImageView.sd_setImage(
            with: URL(string: cellViewModel.userProfileImageUrlString ?? ""),
            placeholderImage: UIImage(named: "avatarImage"),
            options: .continueInBackground
        )
        
        var inputSources: [InputSource] = []
        if let urls = cellViewModel.imageURLs {
            let placeholderImage = UIImage(named: "imagePlaceholder")
            urls.forEach {
                inputSources.append(SDWebImageSource(url: $0, placeholder: placeholderImage))
            }
        }
        cell.imageSlideShow.setImageInputs(inputSources)
        cell.likeButton.setTitle("\(cellViewModel.like)", for: .normal)
        cell.commentButton.setTitle("\(cellViewModel.repliesCount)", for: .normal)
        cell.textView.text = cellViewModel.contents
        
        cell.usernameLabel.text = cellViewModel.userDisplayName
        cell.timeLabel.text = cellViewModel.feedDate
        cell.userVegetarianTypeLabel.text = cellViewModel.vegetarianType
        if cellViewModel.isLike {
            cell.likeImageView.image = UIImage(named: "ThumbLogoActive")
        } else {
            cell.likeImageView.image = UIImage(named: "ThumbLogoInactive")
        }
        cell.feedId = cellViewModel.feedId
        cell.createdUserUid = cellViewModel.userUid
        
        // MARK: - configure cell(no data)
        cell.parentVC = self
        cell.delegate = self
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(didLikeButtonTapped(_:)), for: .touchUpInside)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(textViewTapped(gestureRecognizer:)))
        cell.textView.tag = cellViewModel.dailyLifeID
        cell.textView.addGestureRecognizer(tapGR)
        cell.commentButton.tag = cellViewModel.dailyLifeID
        cell.commentButton.addTarget(self, action: #selector(didTapCommentButton(_:)), for: .touchUpInside)
        
        cell.commentButton.isSelected = true // commentButton은 항상 초록색
        cell.recipeLabledView.isHidden = true
        
        let targetSize = CGSize(width: cell.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let estimatedHeight = ceil(cell.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel).height)
        
        // 저장된 cellHeights와 계산된 estimatedHeight가 다를 때만 reloadData()
        if cellHeights[indexPath.item] != estimatedHeight {
            cellHeights[indexPath.item] = estimatedHeight
            collectionView.reloadData()
        }
        
        return cell
    }
}

extension CommunityDailyLifeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 310 // 바꿀일 없을듯
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width - sectionInsets.left*2
        let height: CGFloat = cellHeights[indexPath.item]
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
}

extension CommunityDailyLifeViewController: CommunityDailyLifeListViewModelDelegate, CommunityCollectionHeaderViewDelegate {

    func didFetchPostList() {
        setCellHeightsArray(numberOfItems: viewModel.numberOfPosts)
        collectionView.reloadData()
        collectionView.refreshControl?.endRefreshing()
    }
    
    func setViewOnlyFollowing(isSelected: Bool) {
        viewOnlyFollowing = isSelected
        viewModel.refreshPostList(interestTypeIDs: interestOptions, regionIds: regionOptions,viewOnlyFollowing: viewOnlyFollowing)
    }
    
    func didSelectChooseInterestButton() {
        guard let vc = ChooseInterestViewController.instantiate() as? ChooseInterestViewController else { return }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func didSelectChooseRegionButton() {
        
        guard let vc = ChooseRegionViewController.instantiate() as? ChooseRegionViewController else { return }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func didDeleteFeed() {
        showSimpleBottomAlert(with: "글 삭제 완료 🎉")
        collectionView.reloadData()
    }
    
    func didCompleteReport() {
        showSimpleBottomAlert(with: "신고 처리가 완료됐어요! 벨런스 팀이 검토 후 조치할게요.👍")
    }
    
    func failedUserRequest(with error: NetworkError) {
        showSimpleBottomAlert(with: error.errorDescription)
    }
    
    func didBlockUser() {
        showSimpleBottomAlert(with: "처리가 완료되었습니다. 피드 새로 고침을 해주세요.")
        collectionView.reloadData()
    }
}

extension CommunityDailyLifeViewController: ChooseRegionDelegate {
    
    func didChooseRegion(region: [String]) {
        
        self.regionOptions = region
        guard let chooseRegionButton = chooseRegionButton else { return }
        if regionOptions.count == 0 {
            chooseRegionButton.isSelected = false
        } else {
            chooseRegionButton.isSelected = true
        }
        viewModel.refreshPostList(interestTypeIDs: interestOptions, regionIds: regionOptions, viewOnlyFollowing: viewOnlyFollowing)
    }
}

// 관심사 선택 Delegate
extension CommunityDailyLifeViewController: ChooseInterestDelegate {
    
    func didSelectInterestOptions(interestOptions: [Int]) {

        self.interestOptions = interestOptions
        guard let chooseInterestButton = chooseInterestButton else { return }
        if interestOptions.count == 0 {
            chooseInterestButton.isSelected = false
        } else {
            chooseInterestButton.isSelected = true
        }
        viewModel.refreshPostList(interestTypeIDs: interestOptions, regionIds: regionOptions, viewOnlyFollowing: viewOnlyFollowing)
    }
}

extension CommunityDailyLifeViewController: CommunityFeedCVCDelegate {
    
    func didChooseToReportUser(type: ReportType.Feed, feedId: Int) {
        viewModel.reportDailyLifeFeed(type: type, feedId: feedId)
    }
    
    func didChooseToBlockUser(userId: String) {
        viewModel.blockUser(targetUserId: userId)
    }
    
    func didChooseToDeleteMyFeed(feedId: Int) {
        viewModel.deleteMyDailyLifeFeed(feedId: feedId)
    }
}

extension CommunityDailyLifeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = collectionView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if contentHeight > frameHeight + 100 && contentOffsetY > contentHeight - frameHeight - 100 && viewModel.hasMore && !viewModel.isFetchingData {
            // fetch more
            viewModel.fetchPostList(interestTypeIDs: interestOptions, regionIds: regionOptions, viewOnlyFollowing: viewOnlyFollowing)
        }
    }
}
