import UIKit
import SDWebImage

class SearchProductViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    private let viewModel = ProductReviewListViewModel(productManager: ProductManager())
    
    static var storyboardName: String {
        StoryboardName.productReview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissProgressBar()
    }
}

//MARK: - ProductReviewListDelegate

extension SearchProductViewController: ProductReviewListDelegate {
    func didFetchProductList() {
        searchCollectionView.reloadData()
    }
    
    func failedFetchingProductList(with error: NetworkError) {
        showSimpleBottomAlert(with: error.errorDescription)
    }

}

//MARK: - UISearchBarDelegate

extension SearchProductViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        guard let searchKeyword = searchBar.text else { return }
        searchBar.resignFirstResponder()
        viewModel.resetValues()
        viewModel.fetchSearchList(productName: searchKeyword)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SearchProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellID.popularProductCVC,
            for: indexPath
        ) as? PopularProductCVC
        else { return UICollectionViewCell() }
        
        let productData = viewModel.productList[indexPath.row]
        
        cell.productTitleLabel.text = productData.name
        cell.productPriceLabel.text = "\(productData.price)원"
        cell.ratingStackView.setStarsRating(rating: Int(productData.rating))
        
        cell.productImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.productImageView.sd_setImage(
            with: URL(string: productData.fileFolder.files[0].path)!,
            placeholderImage: nil,
            options: .continueInBackground
        )

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let vc = ProductReviewViewController.instantiate() as? ProductReviewViewController else { return }
        
        let productData = viewModel.productList[indexPath.row]
        
        vc.productId = productData.productId
        vc.productThumbnailUrl = URL(string: productData.fileFolder.files[0].path)!
        vc.productName = productData.name
        vc.rating = Int(productData.rating)
        vc.price = productData.price
        
        navigationController?.pushViewController(vc, animated: true)
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
        viewModel.delegate = self
        configureSearchBar()
        configureCollectionView()
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "검색하기"
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
