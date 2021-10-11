import UIKit
import SwipeMenuViewController

class ProductReviewListContainerViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var swipeMenuView: SwipeMenuView!
    
    private var titles: [String] = ["즉석조리식품", "즉석섭취식품", "반찬/대체육", "초콜릿/과자", "빵류", "음료류", "양념/소스"]
    
    
    static var storyboardName: String {
        StoryboardName.productReview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    

}

//MARK: - UISearchBarDelegate

extension ProductReviewListContainerViewController: UISearchBarDelegate {
    
}

//MARK: - SwipeMenuViewDelegate

extension ProductReviewListContainerViewController: SwipeMenuViewDelegate {
    
    
}

//MARK: - SwipeMenuViewDataSource

extension ProductReviewListContainerViewController: SwipeMenuViewDataSource {
    
    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return titles.count
    }

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return titles[index]
    }

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        
        return ProductReviewListViewController.instantiate()


    }
    
    
}

//MARK: - Initialization & UI Configuration

extension ProductReviewListContainerViewController {
    
    private func configure() {
        title = "제품 리뷰"
        setClearNavigationBarBackground()
        configureUISearchBar()
        configureSwipeMenuView()
    }
    
    private func configureUISearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "검색하기"
        searchBar.backgroundImage = UIImage()
    

    }
    
    private func configureSwipeMenuView() {
        swipeMenuView.delegate = self
        swipeMenuView.dataSource = self
        
        let options: SwipeMenuViewOptions = .init()
        

        swipeMenuView.reloadData(options: options)
        
    }
    
}
