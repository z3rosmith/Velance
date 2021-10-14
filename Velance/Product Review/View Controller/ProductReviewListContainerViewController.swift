import UIKit
import Segmentio

class ProductReviewListContainerViewController: UIViewController, Storyboarded {
    

    
    @IBOutlet weak var searchBarView: UIView!
    
    @IBOutlet weak var segmentioView: Segmentio!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var addButton: VLFloatingButton!
    
    private var titles: [String] = ["즉석조리식품", "즉석섭취식품", "반찬/대체육", "초콜릿/과자", "빵류", "음료류", "양념/소스"]
    
    fileprivate struct Fonts {
        
        // Segmentio
        static let segmentTitleFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        // Section Title Labels
        static let sectionTitleFont = UIFont.systemFont(ofSize: 17, weight: .bold)
    }
    
    static var storyboardName: String {
        StoryboardName.productReview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}

//MARK: - IBActions

extension ProductReviewListContainerViewController {
    
    @IBAction func pressedFilterOption(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ProductReviewListContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
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
    
    @objc private func pressedSearchBarView() {
        navigationController?.pushViewController(
            SearchProductViewController.instantiate(),
            animated: false
        )
    }

    
    private func configureCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
       
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
        
        let segmentioStates = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: Fonts.segmentTitleFont,
                titleTextColor: .lightGray
            ),
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: Fonts.segmentTitleFont,
                titleTextColor: .black
            ),
            highlightedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .darkGray
            )
        )
        
        var content = [SegmentioItem]()
        
        let items: [SegmentioItem] = [
            SegmentioItem(title: "식품", image: nil),
            SegmentioItem(title: "즉석식품", image: nil),
            SegmentioItem(title: "빵", image: nil),
            SegmentioItem(title: "초콜릿", image: nil),
            SegmentioItem(title: "식품", image: nil),
            SegmentioItem(title: "식품", image: nil),
            SegmentioItem(title: "초콜릿", image: nil),
            SegmentioItem(title: "초콜릿", image: nil),
            SegmentioItem(title: "초콜릿", image: nil),
            SegmentioItem(title: "초콜릿", image: nil),
        ]
        content.append(contentsOf: items)
        
        let horizontalSeparatorOptions = SegmentioHorizontalSeparatorOptions(
            type: .none,
            height: 0,
            color: .gray
        )
        
        let verticalSeparatorOptions = SegmentioVerticalSeparatorOptions(
            ratio: 0.1, // from 0.1 to 1
            color: .clear
        )
        
        let options = SegmentioOptions(
            backgroundColor: .white,
            segmentPosition: .dynamic,
            scrollEnabled: true,
            indicatorOptions: SegmentioIndicatorOptions(
                type: .bottom,
                ratio: 1,
                height: 2,
                color: UIColor(named: Colors.tabBarSelectedColor)!
            ),
            horizontalSeparatorOptions: horizontalSeparatorOptions,
            verticalSeparatorOptions: verticalSeparatorOptions,
            imageContentMode: .center,
            labelTextAlignment: .center,
            segmentStates: segmentioStates
        )
        
        segmentioView.setup(
            content: content,
            style: .onlyLabel,
            options: options
        )
        
        segmentioView.selectedSegmentioIndex = 0
        segmentioView.clipsToBounds = true
    }
    


    
}
