import UIKit
import Segmentio
import SDWebImage

class ProductReviewListContainerViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var segmentioView: Segmentio!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var addButton: VLFloatingButton!
    
    private let viewModel = ProductReviewListViewModel(productManager: ProductManager())
    
    fileprivate struct Fonts {
        
        
        // Section Title Labels
        static let sectionTitleFont = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    static var storyboardName: String {
        StoryboardName.productReview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.fetchProductList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissProgressBar()
    }
    
}

//MARK: - IBActions & Target Methods

extension ProductReviewListContainerViewController {
    
    @IBAction func pressedFilterOption(_ sender: UIButton) {
        sender.isSelected.toggle()
        
    }
    
    @objc private func pressedSearchBarView() {
        navigationController?.pushViewController(
            SearchProductViewController.instantiate(),
            animated: true
        )
    }
    
    @objc private func pressedAddButton() {
        let vc = UploadNewProductViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func refreshCollectionView() {
        viewModel.resetValues()
        viewModel.fetchProductList()
    }
}

//MARK: - ProductReviewListDelegate

extension ProductReviewListContainerViewController: ProductReviewListDelegate {
    
    func didFetchProductList() {
        productCollectionView.refreshControl?.endRefreshing()
        productCollectionView.reloadData()
    }
    
    func failedFetchingProductList(with error: NetworkError) {
        productCollectionView.refreshControl?.endRefreshing()
        showSimpleBottomAlert(with: error.errorDescription)
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ProductReviewListContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            placeholderImage: nil
            ,
            options: .continueInBackground
        )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard  let vc = ProductReviewViewController.instantiate() as? ProductReviewViewController else { return }
        
        
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 50
        let width: CGFloat = (collectionView.bounds.width - itemSpacing) / 2
        return CGSize(width: width, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "\(ProductCollectionReusableView.self)",
                for: indexPath
            )
            
            guard let productHeaderView = headerView as? ProductCollectionReusableView
            else { return headerView }
            
            productHeaderView.configure()
            return productHeaderView
        default: return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        return CGSize(width: width, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0)
    }
}


//MARK: - Initialization & UI Configuration

extension ProductReviewListContainerViewController {
    
    private func configure() {
        title = "제품 리뷰"
        
        viewModel.delegate = self
        
        setNavBarBackButtonItemTitle()
        setClearNavigationBarBackground()
        configureSearchBarView()
        configureCollectionView()
        configureSegmentioView()
        
    }
    
    private func configureSearchBarView() {
        searchBarView.layer.cornerRadius = searchBarView.frame.height / 2
        searchBarView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(pressedSearchBarView)
        )
        searchBarView.addGestureRecognizer(tapGesture)
    }
    
    
    private func configureCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.refreshControl = UIRefreshControl()
        productCollectionView.refreshControl?.addTarget(
            self,
            action: #selector(refreshCollectionView),
            for: .valueChanged
        )
        
        let popularProductNibName = UINib(
            nibName: XIB_ID.popularProductCVC,
            bundle: nil
        )
        productCollectionView.register(
            popularProductNibName,
            forCellWithReuseIdentifier: CellID.popularProductCVC
        )
    }
    
    private func configureSegmentioView() {
        segmentioView.setup(
            content: UIHelper.configureSegmentioIems(),
            style: .onlyLabel,
            options: UIHelper.configureSegmentioOptions()
        )
        
        segmentioView.selectedSegmentioIndex = 0
        segmentioView.clipsToBounds = true
        
        segmentioView.valueDidChange = { _, segmentIndex in
            self.viewModel.selectedProductCategory = segmentIndex + 1
        }
    }
}
