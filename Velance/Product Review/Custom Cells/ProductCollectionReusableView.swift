import UIKit

class ProductCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var similarProductCollectionView: UICollectionView!
    @IBOutlet weak var popularProductLabel: UILabel!
    
    static let reuseId: String = "ProductCollectionReusableView"

    fileprivate struct Metrics {
        static let collectionViewHeight: CGFloat = 150
        static let sectionInsets = UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0)
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("✏️ override init")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("✏️ required init for ProductCollectionReusableView")
    }
}

//MARK: - UICollectionViewDataSource

extension ProductCollectionReusableView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = similarProductCollectionView.dequeueReusableCell(
            withReuseIdentifier: CellID.productForSimilarTasteCVC,
            for: indexPath
        ) as? ProductForSimilarTasteCVC
        else { return UICollectionViewCell() }
        
        cell.productTitleLabel.text = "[\(indexPath.row)] 비건 소세지가 참 맛나 이건 정말 비건비건"
        cell.productVeganTypeLabel.text = "[\(indexPath.row)] 페스코,비건"
        cell.productPriceLabel.text = "10,000원"
        cell.productRatingLabel.text = "\(indexPath.row).3"
        cell.productImageView.image = UIImage(named: "image_test")
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ProductCollectionReusableView: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProductCollectionReusableView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 120)
    }

}

//MARK: - Initialization & UI Configuration

extension ProductCollectionReusableView {
    
    func configure() {
        configureLabel()
        configureCollectionView()
    }
    
    func configureLabel() {
        categoryLabel.text = "당신과 입맛이 비슷한 사용자의 추천!"
        popularProductLabel.text = "인기있는 제품"
        [categoryLabel, popularProductLabel].forEach { label in
            label?.textColor = .black
            label?.textAlignment = .left
            label?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
    }
    
    func configureCollectionView() {
        similarProductCollectionView.dataSource = self
        similarProductCollectionView.delegate = self
        
        let xibName = UINib(
            nibName: XIB_ID.productForSimilarTasteCVC,
            bundle: nil
        )
        similarProductCollectionView.register(
            xibName,
            forCellWithReuseIdentifier: CellID.productForSimilarTasteCVC
        )
    }
}
