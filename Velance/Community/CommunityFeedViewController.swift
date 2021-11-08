import UIKit
import SDWebImage

class CommunityFeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private let viewModel = CommunityFeedViewModel()

    private let headerReuseIdentifier = "CommunityCollectionReusableView2"
    private let cellReuseIdentifier = "CommunityImageCollectionViewCell"
    private let sectionInsets = UIEdgeInsets(top: 3.0, left: 0.0, bottom: 3.0, right: 0.0)
    private let itemsPerRow: CGFloat = 3
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .savedPhotosAlbum
        return imagePicker
    }()
    
    private weak var followButton: UIButton?
    
    var userUID: String = User.shared.userUid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        configureCollectionView()
    }
}

extension CommunityFeedViewController {

    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(
            self,
            action: #selector(refreshCollectionView),
            for: .valueChanged
        )
    }

    private func configureViewModel() {
        viewModel.delegate = self
        viewModel.fetchProfile(userUID: userUID)
        viewModel.fetchUserPostList(userUID: userUID)
    }
    
    @objc private func refreshCollectionView() {
        viewModel.fetchProfile(userUID: userUID)
        viewModel.refreshUserPostList(userUID: userUID)
    }
    
    @objc private func didTapFollowButton(_ sender: UIButton) {
        if !viewModel.isFollowing {
            if sender.isSelected {
                // 팔로우중이므로 언팔
                viewModel.unfollowUser(targetUID: userUID)
            } else {
                viewModel.followUser(targetUID: userUID)
            }
        }
        sender.isSelected.toggle()
    }
}

extension CommunityFeedViewController: UICollectionViewDelegate {


}

extension CommunityFeedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? CommunityCollectionReusableView2 else { fatalError() }
            headerView.delegate = self
            headerView.tagListView.removeAllTags()
            headerView.tagListView.addTags(viewModel.userInterestType)
            headerView.userImageView.sd_setImage(with: viewModel.userImageURL, placeholderImage: UIImage(named: "VelanceAvatar"))
            headerView.usernameLabel.text = viewModel.username
            headerView.userCategoryLabel.text = viewModel.userVegetarianType
            headerView.followerCountLabel.text = "\(viewModel.followers)"
            headerView.followingCountLabel.text = "\(viewModel.followings)"
            headerView.followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
            followButton = headerView.followButton
            
            if userUID == User.shared.userUid {
                headerView.followButton.isHidden = true
            } else {
                headerView.editUserImageButton.isHidden = true
                headerView.editUserinfoButton.isHidden = true
            }
            return headerView
        default:
            fatalError()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfFeeds
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? CommunityImageCollectionViewCell else { fatalError() }
        if viewModel.numberOfFeeds == 0 { return cell }
        let cellViewModel = viewModel.feedAtIndex(indexPath.item)
        cell.imageView.sd_setImage(with: cellViewModel.feedThumbnailURL, placeholderImage: UIImage(named: MockData.mockFoodImageName[0]))
        return cell
    }
}

extension CommunityFeedViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = 230 // 바꿀일 없을듯
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.top * (itemsPerRow - 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
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

extension CommunityFeedViewController: CommunityFeedViewModelDelegate {

    func didFetchProfile() {
        collectionView.reloadData()
        collectionView.refreshControl?.endRefreshing()
    }
    
    func didFetchUserFeedList() {
        collectionView.reloadData()
        collectionView.refreshControl?.endRefreshing()
    }
    
    func didFollow() {
        followButton?.isSelected = true
        viewModel.fetchProfile(userUID: userUID)
    }
    
    func didUnfollow() {
        followButton?.isSelected = false
        viewModel.fetchProfile(userUID: userUID)
    }
}

extension CommunityFeedViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = collectionView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if contentHeight > frameHeight + 100 && contentOffsetY > contentHeight - frameHeight - 100 && viewModel.hasMore && !viewModel.isFetchingPost {
            // fetch more
            viewModel.fetchUserPostList(userUID: userUID)
        }
    }
}

extension CommunityFeedViewController: CommunityReusableDelegate {
    
    func didChooseToEditProfileImage() {
        
        let library = UIAlertAction(
            title: "앨범에서 선택",
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.present(self.imagePicker, animated: true)
        }
        let remove = UIAlertAction(
            title: "프로필 사진 제거",
            style: .default
        ) { [weak self] _ in
            self?.presentAlertWithConfirmAction(
                title: "프로필 사진 제거",
                message: "정말로 제거하시겠습니까?"
            ) { selectedOk in
                if selectedOk { self?.removeProfileImage() }
            }
        }

        let actionSheet = UIHelper.createActionSheet(with: [library, remove], title: "프로필 사진 변경" )
        present(actionSheet, animated: true, completion: nil)
        
    }
}


extension CommunityFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            dismiss(animated: true) {
                self.presentAlertWithConfirmAction(
                    title: "프로필 사진 변경",
                    message: "선택하신 이미지로 프로필 사진을 변경하시겠습니까?"
                ) { selectedOk in
                    if selectedOk {
                        showProgressBar()
                        OperationQueue().addOperation {
                            guard let imageData = originalImage.jpegData(compressionQuality: 0.9) else {
                                return
                            }
                            self.updateProfileImage(imageData: imageData)
                            dismissProgressBar()
                        }
                    } else {
                        self.imagePickerControllerDidCancel(self.imagePicker)
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func removeProfileImage() {
        UserManager.shared.removeUserProfileImage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.showSimpleBottomAlert(with: "프로필 이미지 제거 성공 🎉")
                self.refreshCollectionView()
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
    }
    
    func updateProfileImage(imageData: Data) {
        
        UserManager.shared.updateUserProfileImage(imageData: imageData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.showSimpleBottomAlert(with: "프로필 이미지 변경 성공 🎉")
                self.refreshCollectionView()
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
        
    }
}
