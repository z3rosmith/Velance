import UIKit
import Parchment

class CommunityViewController: UIViewController {
    
    private let pagingViewController = PagingViewController()
    private let titles = ["🥗 레시피", "🗓 일상", "내 피드"]
    
    fileprivate struct Metrics {
        static let fontSize: CGFloat = 14
        static let foodCategoryColor = UIColor(named: "FoodCategorySelectedColor")!
        static let appBackgroundColor = UIColor(named: Colors.appBackgroundColor)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupPagingViewController()
    }
}

extension CommunityViewController {
    
    private func setupNavigationBar() {
        navigationItem.title = "레시피/커뮤니티"
    }
    
    private func setupPagingViewController() {
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pagingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        pagingViewController.dataSource = self
        
        pagingViewController.menuItemSize = .fixed(width: 110, height: 40)
        pagingViewController.indicatorOptions = .visible(
            height: 2,
            zIndex: Int.max,
            spacing: UIEdgeInsets.zero,
            insets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        )
        pagingViewController.indicatorColor = UIColor(named: Colors.tabBarSelectedColor)!
        pagingViewController.selectedTextColor = .black
        
    }
}

extension CommunityViewController: PagingViewControllerDataSource {
    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
        return 3
    }
    
    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
        if index == 0 {
            guard let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "CommunityRecipeViewController") as? CommunityRecipeViewController else { fatalError() }
            vc1.view.layoutIfNeeded() // ! 이걸 하지않으면 vc1에서 view.frame.width가 원래 width의 2배가 되어버리는 현상 발생. Parchment 오류인듯 !
            return vc1
        } else if index == 1 {
            guard let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "CommunityDailyLifeViewController") as? CommunityDailyLifeViewController else { fatalError() }
            vc2.view.layoutIfNeeded()
            return vc2
        } else {
            guard let vc3 = self.storyboard?.instantiateViewController(withIdentifier: "CommunityFeedViewController") as? CommunityFeedViewController else { fatalError() }
            vc3.view.layoutIfNeeded()
            return vc3
        }
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: titles[index])
    }
}

