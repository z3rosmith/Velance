import UIKit

protocol PopularProductTableViewCellDelegate: AnyObject {
    func didTapRecipeTableViewCell(with title: String)
}

class PopularProductTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var popularProductCollectionView: UICollectionView!
    
    weak var delegate: PopularProductTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}



extension PopularProductTableViewCell: RecipeCollectionViewCellDelegate {
    
    func didTapRecipeCVC(with title: String, cell: RecipeCollectionViewCell) {
        let indexPath = popularProductCollectionView.indexPath(for: cell)
        
        guard let index = indexPath?.item else { return }
        
        delegate?.didTapRecipeTableViewCell(with: title)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension PopularProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = popularProductCollectionView.dequeueReusableCell(
            withReuseIdentifier: CellID.popularProductCVC,
            for: indexPath
        ) as? PopularProductCVC
        else { return UICollectionViewCell() }
        
        cell.productTitleLabel.text = "[\(indexPath.row)] 비건 템페가 맛있는 채식 주의 냠냠 비건 좋아"
        cell.productPriceLabel.text = "23,000원"
        cell.ratingStackView.setStarsRating(rating: 4)
        cell.productImageView.image = UIImage(named: "image_test")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10 // 가로에서 cell과 cell 사이의 거리
        let width: CGFloat = (collectionView.bounds.width - itemSpacing)/2 // 셀 하나의 너비
        return CGSize(width: width, height: 240)
    }
}

//MARK: - UI Configuration

extension PopularProductTableViewCell {
    
    private func configureCollectionView() {
        popularProductCollectionView.delegate = self
        popularProductCollectionView.dataSource = self
        
        let nibNamePopularProduct = UINib(
            nibName: XIB_ID.popularProductCVC,
            bundle: nil
        )
        popularProductCollectionView.register(
            nibNamePopularProduct,
            forCellWithReuseIdentifier: CellID.popularProductCVC
        )
    }
}
