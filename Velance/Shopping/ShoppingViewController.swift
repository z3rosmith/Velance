import UIKit
import SDWebImage

class ShoppingViewController: UIViewController {
    
    @IBOutlet weak var shoppingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    
    @objc private func refreshPage() {
        
    }

}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension ShoppingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellID.shoppingTableViewCell,
                for: indexPath
        ) as? ShoppingTableViewCell
        else { return UITableViewCell() }
        
        cell.sectionTitleLabel.text = String(indexPath.row)
        cell.itemCollectionView.reloadData()
      
        
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
        configureTableView()
    }
    
    private func configureTableView() {
        shoppingTableView.delegate = self
        shoppingTableView.dataSource = self
        shoppingTableView.separatorColor = .clear
        shoppingTableView.refreshControl = UIRefreshControl()
        shoppingTableView.refreshControl?.addTarget(
            self,
            action: #selector(refreshPage),
            for: .valueChanged
        )
        
    }
    
}
