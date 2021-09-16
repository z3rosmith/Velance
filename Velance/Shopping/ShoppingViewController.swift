import UIKit
import SDWebImage

class ShoppingViewController: UIViewController {
    
    @IBOutlet weak var leftSegmentView: UIView!
    @IBOutlet weak var leftSegmentLabel: UILabel!
    
    @IBOutlet weak var rightSegmentView: UIView!
    @IBOutlet weak var rightSegmentLabel: UILabel!
    
    @IBOutlet weak var shoppingTableView: UITableView!
    
    private let segmentViewCornerRadius: CGFloat = 20
    
    private let viewModel = ShoppingViewModel()
    
    private var selectedIndex: Int = 0 {
        didSet {
            shoppingTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

//MARK: - Methods

extension ShoppingViewController {
    
    @objc private func refreshPage() {
        
    }

}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension ShoppingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectedIndex == 0 ? configureShoppingTableViewCell(for: indexPath) : configureRecipeTableViewCell(for: indexPath)
        
        

        return cell
    }
    
    func configureShoppingTableViewCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = shoppingTableView.dequeueReusableCell(
            withIdentifier: CellID.shoppingTableViewCell,
            for: indexPath
        ) as? ShoppingTableViewCell
        else { return UITableViewCell() }
        
        cell.sectionTitleLabel.text = "\(indexPath.row)이 풍부한 식품 추천"
        
        return cell
    }
    
    func configureRecipeTableViewCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let cell = shoppingTableView.dequeueReusableCell(
            withIdentifier: CellID.recipeTableViewCell,
            for: indexPath
        ) as? RecipeTableViewCell
        else { return UITableViewCell() }
        
        
        cell.sectionTitleLabel.text = "\(indexPath.row)이 풍부한 레시피 추천"
        
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

//MARK: - UI Configuration

extension ShoppingViewController {
    
    private func configure() {
        navigationController?.navigationBar.barTintColor = UIColor(named: Colors.appDefaultColor)
        configureTableView()
        configureSegmentViews()
    }
    
    private func configureTableView() {
        shoppingTableView.delegate = self
        shoppingTableView.dataSource = self
        shoppingTableView.separatorStyle = .none
        shoppingTableView.refreshControl = UIRefreshControl()
        shoppingTableView.refreshControl?.addTarget(
            self,
            action: #selector(refreshPage),
            for: .valueChanged
        )
    }
    
    private func configureSegmentViews() {
        [leftSegmentView,rightSegmentView].forEach { view in
            view?.layer.cornerRadius = segmentViewCornerRadius
            view?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        let leftTap = UITapGestureRecognizer(
            target: self,
            action: #selector(pressedLeftSegmentView(_:))
        )
        let rightTap = UITapGestureRecognizer(
            target: self,
            action: #selector(pressedRightSegmentView(_:))
        )
        
        leftSegmentView.addGestureRecognizer(leftTap)
        rightSegmentView.addGestureRecognizer(rightTap)
    }
    
    @objc private func pressedLeftSegmentView(_ gesture: UITapGestureRecognizer) {
        rightSegmentView.backgroundColor = .systemGray2
        rightSegmentLabel.textColor = .white
        
        leftSegmentView.backgroundColor = .white
        leftSegmentLabel.textColor = .darkGray
        
        selectedIndex = 0
    }
    
    @objc private func pressedRightSegmentView(_ gesture: UITapGestureRecognizer) {
        leftSegmentView.backgroundColor = .systemGray2
        leftSegmentLabel.textColor = .white
        
        rightSegmentView.backgroundColor = .white
        rightSegmentLabel.textColor = .darkGray
        
        selectedIndex = 1
    }
    
}
