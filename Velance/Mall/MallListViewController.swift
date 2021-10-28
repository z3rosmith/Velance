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
        addMallButton.layer.cornerRadius = addMallButton.frame.height/2
    }
}

extension MallListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
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
        cell.menuCountLabel.text = "비건 메뉴: \(cellViewModel.menuCount)개"
        cell.mallAddressLabel.text = cellViewModel.mallAddress
        cell.semiVeganLabel.isHidden = cellViewModel.onlyVegan
        cell.veganLabel.isHidden = !cellViewModel.onlyVegan
        cell.mallImageView.sd_setImage(with: cellViewModel.imageURL, placeholderImage: UIImage(systemName: "photo.on.rectangle"))
        
        return cell
    }
}

extension MallListViewController: MallListViewModelDelegate {
    func didFetchMallList() {
        tableView.reloadData()
    }
}
