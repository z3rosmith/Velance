import UIKit
import SnapKit

class ProductCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var similarProductCollectionView: UICollectionView!
    
    static let reuseId: String = "ProductCollectionReusableView"

    fileprivate struct Metrics {
        static let collectionViewHeight: CGFloat = 150
        static let sectionInsets = UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    func configure() {
        configureLabel()
        configureCollectionView()
    }
    
    func configureLabel() {
        categoryLabel.text = "당신과 입맛이 비슷한 사용자의 추천!"
        categoryLabel.textColor = .black
        categoryLabel.textAlignment = .left
        categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    func configureCollectionView() {
        similarProductCollectionView.dataSource = self
        similarProductCollectionView.delegate = self
        similarProductCollectionView.register(
            ProductForSimilarTasteCVC.self,
            forCellWithReuseIdentifier: CellID.productForSimilarTasteCVC
        )
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

        cell.productTitleLabel.text = "[\(indexPath.row)] 비건 소세지"
        cell.productVeganTypeLabel.text = "[\(indexPath.row)] 페스코,비건"
        cell.productPriceLabel.text = "[\(indexPath.row)] 10,000원"
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
        return CGSize(width: 280, height: 140)
    }
}
