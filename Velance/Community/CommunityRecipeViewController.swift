import UIKit
import ImageSlideshow

class CommunityRecipeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = CommunityRecipeListViewModel()
    
    // 레시피VC인지 일상VC인지 구분
    var isRecipeVC: Bool = true
    
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    private let headerReuseIdentifier = "CommunityCollectionReusableView1"
    private let cellReuseIdentifier = "CommunityFeedCollectionViewCell"
    
    private var cellHeights: [CGFloat] = []
    private let basicCellHeight: CGFloat = 570
    
    private var recipeCategoryID: Int? = nil
    private var viewOnlyFollowing: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.delegate = self
        viewModel.fetchPostList(recipeCategoryID: recipeCategoryID, viewOnlyFollowing: viewOnlyFollowing)
    }
}

extension CommunityRecipeViewController {
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CommunityFeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    /// dynamic collection view cell height를 위해서 basicCellHeight를 numberOfItems 개수만큼 저장함
    private func setCellHeightsArray(numberOfItems: Int) {
        cellHeights = Array<CGFloat>(repeating: basicCellHeight, count: numberOfItems)
    }
    
    @objc private func didLikeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @objc private func didTapCommentButton(_ sender: UIButton) {
        print("---> tag: \(sender.tag)")
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CommunityDetailViewController") as? CommunityDetailViewController else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func textViewTapped(gestureRecognizer: UIGestureRecognizer) {
        guard let tag = gestureRecognizer.view?.tag else { return }
        print("---> tag: \(tag)")
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "CommunityDetailViewController") as? CommunityDetailViewController else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension CommunityRecipeViewController: UICollectionViewDelegate {
    
}

extension CommunityRecipeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? CommunityCollectionReusableView1 else { fatalError() }
            if isRecipeVC {
                headerView.chooseInterestsButton.isHidden = true
                headerView.categoryCollectionView.isHidden = false
                headerView.delegate = self
            } else {
                headerView.chooseInterestsButton.isHidden = false
                headerView.categoryCollectionView.isHidden = true
            }
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
        let cellViewModel = viewModel.postAtIndex(indexPath.item)
        
        // MARK: - configure cell(data)
        cell.userImageView.image = UIImage(named: "userImage_test") // 준수님이 업데이트하면 수정
        
        var inputSources: [InputSource] = []
        if let urls = cellViewModel.imageURLs {
            let placeholderImage = UIImage(systemName: "photo.on.rectangle")
            urls.forEach {
                inputSources.append(SDWebImageSource(url: $0, placeholder: placeholderImage))
            }
        }
        cell.imageSlideShow.setImageInputs(inputSources)
        cell.likeButton.setRightText(text: "341") // 준수님이 업데이트하면 수정
        cell.commentButton.setRightText(text: "12") // 준수님이 업데이트하면 수정
        cell.textView.text = cellViewModel.contents
        
        cell.usernameLabel.text = cellViewModel.userDisplayName
        cell.timeLabel.text = cellViewModel.feedDate
        cell.userVegetarianTypeLabel.text = "페스코" // 준수님이 업데이트하면 수정
//        cell.likeButton.isSelected = cellViewModel.didUserTapLike // 준수님이 업데이트하면 수정
        
        // MARK: - configure cell(no data)
        cell.parentVC = self
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(didLikeButtonTapped(_:)), for: .touchUpInside)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(textViewTapped(gestureRecognizer:)))
        cell.textView.tag = indexPath.item
        cell.textView.addGestureRecognizer(tapGR)
        cell.commentButton.tag = indexPath.item
        cell.commentButton.addTarget(self, action: #selector(didTapCommentButton(_:)), for: .touchUpInside)
        
        cell.commentButton.isSelected = true // commentButton은 항상 초록색
        
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

extension CommunityRecipeViewController: UICollectionViewDelegateFlowLayout {
    
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

extension CommunityRecipeViewController: CommunityRecipeListViewModelDelegate, CommunityCollectionHeaderViewDelegate {
    
    func didFetchPostList() {
        setCellHeightsArray(numberOfItems: viewModel.numberOfPosts)
        collectionView.reloadData()
    }
    
    func didSelectCategoryItemAt(_ index: Int) {
        recipeCategoryID = index == 0 ? nil : index
        viewModel.refreshPostList(recipeCategoryID: recipeCategoryID, viewOnlyFollowing: viewOnlyFollowing)
    }
    
    func setViewOnlyFollowing(isSelected: Bool) {
        viewOnlyFollowing = isSelected
        viewModel.refreshPostList(recipeCategoryID: recipeCategoryID, viewOnlyFollowing: viewOnlyFollowing)
    }
    
    func didSelectChooseInterestButton() {
        guard let vc = ChooseInterestViewController.instantiate() as? ChooseInterestViewController else { return }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.delegate = self
        self.present(vc, animated: true)
    }
}

// 관심사 선택 Delegate

extension CommunityRecipeViewController: ChooseInterestDelegate {
    
    func didSelectInterestOptions(interestOptions: [Int]) {
        
        
    }
}
