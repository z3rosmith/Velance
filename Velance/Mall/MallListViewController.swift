import UIKit
import SDWebImage

struct MallPoint {
    
    let x, y, radius: Double
}

class MallListViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMallButton: UIButton!
    
    private let cellReuseIdentifier = "MallTableViewCell"
    private let viewModel = MallListViewModel()
    
    var mallPoint: MallPoint!
    
    static var storyboardName: String {
        StoryboardName.mall
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        configureUI()
        viewModel.delegate = self
        viewModel.fetchMallList(mallPoint: mallPoint)
        setNavBarBackButtonItemTitle()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
    }
    
    @IBAction func pressedAddMallButton(_ sender: UIButton) {
        guard let vc = SearchNewMallViewController.instantiate() as? SearchNewMallViewController else { return }
        vc.currentLocation = MTMapPointGeo(latitude: mallPoint.y, longitude: mallPoint.x)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MallListViewController {
     
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MallTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        tableView.separatorStyle = .none
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didDragTableView), for: .valueChanged)
    }
    
    private func configureUI() {
        navigationItem.title = "식당 목록"
        addMallButton.layer.cornerRadius = addMallButton.frame.height/2
    }
    
    @objc private func didDragTableView() {
        viewModel.refreshMallList(mallPoint: mallPoint)
    }
}

extension MallListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension MallListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfMalls
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? MallTableViewCell else { fatalError() }
        if viewModel.numberOfMalls == 0 { return cell }
        let cellViewModel = viewModel.mallAtIndex(indexPath.row)
        
        cell.mallnameLabel.text = cellViewModel.mallName
        cell.mallAddressLabel.text = cellViewModel.mallAddress
        cell.semiVeganLabel.isHidden = cellViewModel.onlyVegan
        cell.veganLabel.isHidden = !cellViewModel.onlyVegan
        cell.mallImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.mallImageView.sd_setImage(with: cellViewModel.imageURL, placeholderImage: UIImage(named: "placeholderImage"))
        
        cell.menuCountLabel.text = "비건 메뉴: \(cellViewModel.menuCount)개"
        let attributtedString = NSMutableAttributedString(string: cell.menuCountLabel.text!)
        attributtedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "4D8800")!, range: (cell.menuCountLabel.text! as NSString).range(of:"\(cellViewModel.menuCount)"))
        cell.menuCountLabel.attributedText = attributtedString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let cellViewModel = viewModel.mallAtIndex(indexPath.row)
        
        guard let mallVC = MallViewController.instantiate() as? MallViewController else { return }

        mallVC.mallId = cellViewModel.mallId
        mallVC.mallName = cellViewModel.mallName
        mallVC.isVegan = cellViewModel.isVegan
        mallVC.mallAddress = cellViewModel.mallAddress
        mallVC.mallThumbnailUrl = cellViewModel.imageURL
        
        navigationController?.pushViewController(mallVC, animated: true)
    }
}

extension MallListViewController: MallListViewModelDelegate {
    func didFetchMallList() {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
        
        if viewModel.numberOfMalls == 0 {
            tableView.setEmptyMessage("검색된 식당이 없습니다.🧐")
        } else { tableView.restore() }
    }
}

extension MallListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if contentHeight > frameHeight + 100 && contentOffsetY > contentHeight - frameHeight - 100 && viewModel.hasMore && !viewModel.isFetchingData {
            // fetch more
            viewModel.fetchMallList(mallPoint: mallPoint)
        }
    }
}
