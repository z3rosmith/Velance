import UIKit
import SDWebImage

class ProductCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var similarProductCollectionView: UICollectionView!
    @IBOutlet weak var popularProductLabel: UILabel!
    
    private let viewModel = ProductReviewListViewModel(productManager: ProductManager())
    
    static let reuseId: String = "ProductCollectionReusableView"

    fileprivate struct Metrics {
        static let collectionViewHeight: CGFloat = 150
        static let sectionInsets = UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0)
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - UICollectionViewDataSource

extension ProductCollectionReusableView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.similarTasteProductList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let cell = similarProductCollectionView.dequeueReusableCell(
            withReuseIdentifier: CellID.productForSimilarTasteCVC,
            for: indexPath
        ) as? ProductForSimilarTasteCVC
        else { return ProductForSimilarTasteCVC() }
                
        let productData = viewModel.similarTasteProductList[indexPath.row]
    
        cell.productTitleLabel.text = productData.name
        
        
        cell.productImageView.image = UIImage(named: MockData.mockFoodImageName[Int.random(in: 0..<MockData.mockFoodImageName.count)]) // 수정 필요!!
        
    
//        cell.productImageView.sd_setImage(with: URL(string: productData.fileFolder.files[0].path)!, completed: nil)
        cell.productPriceLabel.text = "\(productData.price)원"
        cell.productRatingLabel.text = String(format: "%.1f", productData.rating)
        
        
        
//        let randomIndex: Int = Int.random(in: 0..<MockData.mockFoodImageName.count)
//        cell.productTitleLabel.text = MockData.mockFoodName[randomIndex]
//        cell.productImageView.image = UIImage(named: MockData.mockFoodImageName[randomIndex])
//        cell.productPriceLabel.text = "\(Int.random(in: 1..<4))0,980원"
//        cell.productRatingLabel.text = "\(Int.random(in: 2..<5)).\(Int.random(in: 2..<9))"
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProductCollectionReusableView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 120)
    }

}

//MARK: - ProductReviewListDelegate

extension ProductCollectionReusableView: ProductReviewListDelegate {
    
    func didFetchSimilarTasteProductList() {
        print("✏️ didFetchSimilarTasteProductList: \(viewModel.similarTasteProductList)")
        similarProductCollectionView.reloadData()
    }
    
    func failedFetchingProductList(with error: NetworkError) {
       
    }
}

//MARK: - Initialization & UI Configuration

extension ProductCollectionReusableView {
    
    func configure() {
        configureLabel()
        configureCollectionView()
        viewModel.delegate = self
        viewModel.fetchSimilarTasteProductList()
    }
    
    func configureLabel() {
        
        categoryLabel.text = "당신과 입맛이 비슷한 사용자의 추천!"
        let text = categoryLabel.text ?? ""
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "입맛")
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.blue,
            range: range
        )
        
        categoryLabel.attributedText = attributedString

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
