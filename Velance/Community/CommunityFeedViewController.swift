import UIKit
import SDWebImage

class CommunityFeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

//    private let viewModel = CommunityFeedViewModel()

    private let headerReuseIdentifier = "CommunityCollectionReusableView2"
    private let cellReuseIdentifier = "CommunityImageCollectionViewCell"
    private let sectionInsets = UIEdgeInsets(top: 3.0, left: 0.0, bottom: 3.0, right: 0.0)
    private let itemsPerRow: CGFloat = 3

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
    }

    private func configureViewModel() {
//        viewModel.delegate = self
//        viewModel.fetchProfile(userUID: User.shared.userUid)
    }
}

extension CommunityFeedViewController: UICollectionViewDelegate {


}

extension CommunityFeedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as? CommunityCollectionReusableView2 else { fatalError() }
//            headerView.tagListView.removeAllTags()
//            headerView.tagListView.addTags(viewModel.userInterestType)
//            headerView.userImageView.sd_setImage(with: viewModel.userImageURL, placeholderImage: UIImage(named: "mockAvatar7"))
//            headerView.usernameLabel.text = viewModel.username
//            headerView.userCategoryLabel.text = viewModel.userVegetarianType
//            headerView.followerCountLabel.text = "\(viewModel.followers)"
//            headerView.followingCountLabel.text = "\(viewModel.followings)"
            return headerView
        default:
            fatalError()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? CommunityImageCollectionViewCell else { fatalError() }

        let randomIndex = Int.random(in: 0..<MockData.mockFoodImageName.count)

        cell.imageView.image = UIImage(named: MockData.mockFoodImageName[randomIndex])
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

//extension CommunityFeedViewController: CommunityFeedViewModelDelegate {
//
//    func didFetchProfile() {
//        print("🙌 didFetchProfile")
//        collectionView.reloadData()
//    }
//}
