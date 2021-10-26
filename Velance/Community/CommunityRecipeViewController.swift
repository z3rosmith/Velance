import UIKit
import ImageSlideshow

class CommunityRecipeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // 레시피VC인지 일상VC인지 구분
    var isRecipeVC: Bool = true
    
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    private let headerReuseIdentifier = "CommunityCollectionReusableView1"
    private let cellReuseIdentifier = "CommunityFeedCollectionViewCell"
    
    private var cellHeights: [CGFloat] = []
    private let basicCellHeight: CGFloat = 570
    private var numberOfItems: Int = 5 // 네트워킹 해서 didFetch에서 setCellHeightsArray(numberOfItems:)를 불러줘야함
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setCellHeightsArray(numberOfItems: numberOfItems)
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
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? CommunityFeedCollectionViewCell else { fatalError() }
        cell.parentVC = self
        cell.layer.cornerRadius = 20
        cell.userImageView.image = UIImage(named: "userImage_test")
        cell.imageSlideShow.setImageInputs([
            ImageSource(image: UIImage(named: "image_test")!),
            SDWebImageSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!,
            SDWebImageSource(urlString: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg")!
        ])
        cell.likeButton.setRightText(text: "341")
        cell.commentButton.setRightText(text: "12")
        cell.commentButton.isSelected = true // commentButton은 항상 초록색
        
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(didLikeButtonTapped(_:)), for: .touchUpInside)
        
        if indexPath.item == 0 {
            cell.textView.text = "오늘 방문한 수성구 비건 식당입니다!\n가격도 괜찮고 페스코 여러분께 추천드리는 식당입니다!\n한 번 들러보시면 좋을 것 같아요 ㅎㅎ\ndddd\ndddd"
        } else if indexPath.item == 1 {
            cell.textView.text = "오늘 요리한 샌드위치 레시피입니다 :)  우유 500ml, 로메인 2장, 통밀빵 1개 정도만 있으면 되더라고요!"
        } else if indexPath.item == 2 {
            cell.textView.text = "ddd"
        } else {
            cell.textView.text = "오늘 방문한 수성구 비건 식당입니다!\n가격도 괜찮고 페스코 여러분께 추천드리는 식당입니다!\n한 번 들러보시면 좋을 것 같아요 ㅎㅎ오늘 방문한 수성구 비건 식당입니다!\n가격도 괜찮고 페스코 여러분께 추천드리는 식당입니다!\n한 번 들러보시면 좋을 것 같아요 ㅎㅎ오늘 방문한 수성구 비건 식당입니다!\n가격도 괜찮고 페스코 여러분께 추천드리는 식당입니다!\n한 번 들러보시면 좋을 것 같아요 ㅎㅎ"
        }
        
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
