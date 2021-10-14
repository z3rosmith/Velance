import UIKit

class SearchProductViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    static var storyboardName: String {
        StoryboardName.productReview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    


}

//MARK: - UISearchBarDelegate

extension SearchProductViewController: UISearchBarDelegate {
    
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SearchProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellID.popularProductCVC,
            for: indexPath
        ) as? PopularProductCVC
        else { return UICollectionViewCell() }

        cell.productTitleLabel.text = "[\(indexPath.row)] 비건 템페가 맛있는 채식 주의 냠냠 비건 좋아"
        cell.productVeganTypeLabel.text = "[\(indexPath.row)] 락토/오보"
        cell.productPriceLabel.text = "23,000원"
        cell.ratingStackView.setStarsRating(rating: 4)
        cell.productImageView.image = UIImage(named: "image_test")

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 50
        let width: CGFloat = (collectionView.bounds.width - itemSpacing) / 2
        return CGSize(width: width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12.0, left: 12.0, bottom: 0, right: 12.0)
    }
    
    
}

//MARK: - Initialization & UI Configuration

extension SearchProductViewController {
    
    private func configure() {
        title = "검색 결과"
        configureSearchBar()
        configureCollectionView()
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
    }
    
    private func configureCollectionView() {
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
       
        let popularProductNibName = UINib(
            nibName: XIB_ID.popularProductCVC,
            bundle: nil
        )
        searchCollectionView.register(
            popularProductNibName,
            forCellWithReuseIdentifier: CellID.popularProductCVC
        )
        
    }
    
 
}
