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
        if indexPath.row % 2 == 0 {
            cell.semiVeganLabel.isHidden = true
        } else {
            cell.veganLabel.isHidden = true
        }
        cell.mallImageView.image = UIImage(named: "image_test")
        return cell
    }
}

extension MallListViewController: MallListViewModelDelegate {
    func didFetchMallList() {
        tableView.reloadData()
    }
}
