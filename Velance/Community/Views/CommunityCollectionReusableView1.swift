import UIKit

protocol CommunityCollectionHeaderViewDelegate: AnyObject {
    func didSelectCategoryItemAt(_ index: Int)
    func setViewOnlyFollowing(isSelected: Bool)
}

class CommunityCollectionReusableView1: UICollectionReusableView {
    
    @IBOutlet weak var viewFollowingButton: UIButton!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var chooseInterestsButton: UIButton!
    @IBOutlet weak var recommandLabel: UILabel!
    @IBOutlet weak var similarUserCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionViewHeight: NSLayoutConstraint!
    
    private lazy var categoryCellHeight: CGFloat = categoryCollectionViewHeight.constant - 15
    
    private let sectionInsets1 = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    private let sectionInsets2 = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
    private let categories = ["최신순", "한식", "중식", "일식", "분식", "아시아/양식", "카페/디저트"]
    private let categoryReuseIdentifier = "CategoryCollectionViewCell"
    private let similarUserReuseIdentifier = "SimilarUserCollectionViewCell"
    
    weak var delegate: CommunityCollectionHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupCollectionView()
    }
    
    private func setupUI() {
        viewFollowingButton.setImage(UIImage(systemName: "square"), for: .normal)
        viewFollowingButton.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        chooseInterestsButton.setTitle("관심사 선택하기", for: .normal)
        chooseInterestsButton.setTitle("관심사 선택됨", for: .selected)
    }
    
    private func setupCollectionView() {
        [categoryCollectionView, similarUserCollectionView].compactMap { $0 }.forEach {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            $0.delegate = self
            $0.dataSource = self
            $0.collectionViewLayout = layout
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
        
        similarUserCollectionView.register(UINib(nibName: "SimilarUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: similarUserReuseIdentifier)
    }
    
    @IBAction func viewFollowingButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.setViewOnlyFollowing(isSelected: sender.isSelected)
    }
}

extension CommunityCollectionReusableView1: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        } else {
            return 5 // 추후 네트워킹 해서 받아오기
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryReuseIdentifier, for: indexPath) as? CategoryCollectionViewCell else { fatalError() }
            
            cell.categoryLabel.text = categories[indexPath.item]
            cell.backgroundColor = .clear
            cell.categoryLabel.textColor = .gray
            cell.layer.cornerRadius = categoryCellHeight/2
            
            if indexPath.item == 0 {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
                cell.isSelected = true
                cell.backgroundColor = UIColor(named: Colors.foodCategorySelectedColor)!
                cell.categoryLabel.textColor = UIColor(named: Colors.appBackgroundColor)!
            }
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: similarUserReuseIdentifier, for: indexPath) as? SimilarUserCollectionViewCell else { fatalError() }
            
            cell.userImageView.image = UIImage(named: "userImage_test")
            cell.usernameLabel.text = "CJ Chung"
            cell.userStyleLabel.text = "페스코"
            cell.layer.cornerRadius = 20
            
            return cell // 추후 네트워킹 해서 받아오기
        }
    }
}

extension CommunityCollectionReusableView1: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
            cell.backgroundColor = UIColor(named: Colors.foodCategorySelectedColor)!
            cell.categoryLabel.textColor = UIColor(named: Colors.appBackgroundColor)!
            delegate?.didSelectCategoryItemAt(indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
            cell.backgroundColor = .clear
            cell.categoryLabel.textColor = .gray
        }
    }
}

extension CommunityCollectionReusableView1: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: 85, height: categoryCellHeight)
        } else {
            return CGSize(width: 135, height: 185)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == categoryCollectionView {
            return sectionInsets1
        } else {
            return sectionInsets2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollectionView {
            return sectionInsets1.left
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollectionView {
            return sectionInsets1.left
        } else {
            return 10
        }
    }
}
