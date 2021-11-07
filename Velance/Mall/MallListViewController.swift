import UIKit

struct MallPoint {
    
    let x, y, radius: Double
}

class MallListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMallButton: UIButton!
    
    private let cellReuseIdentifier = "MallTableViewCell"
    private let viewModel = MallListViewModel()
    
    var mallPoint: MallPoint!
    
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
    }
    
    private func configureUI() {
        navigationItem.title = "식당 목록"
        addMallButton.layer.cornerRadius = addMallButton.frame.height/2
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
        let cellViewModel = viewModel.mallAtIndex(indexPath.row)
        
        cell.mallnameLabel.text = cellViewModel.mallName
        cell.mallAddressLabel.text = cellViewModel.mallAddress
        cell.semiVeganLabel.isHidden = cellViewModel.onlyVegan
        cell.veganLabel.isHidden = !cellViewModel.onlyVegan
        cell.mallImageView.sd_setImage(with: cellViewModel.imageURL, placeholderImage: UIImage(systemName: "photo.on.rectangle"))
        
        cell.menuCountLabel.text = "비건 메뉴: \(cellViewModel.menuCount)개"
        let attributtedString = NSMutableAttributedString(string: cell.menuCountLabel.text!)
        attributtedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(named: "4D8800")!, range: (cell.menuCountLabel.text! as NSString).range(of:"\(cellViewModel.menuCount)"))
        cell.menuCountLabel.attributedText = attributtedString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
    }
}
