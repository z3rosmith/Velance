//
//  MallListViewController.swift
//  Velance
//
//  Created by Jinyoung Kim on 2021/10/26.
//

import UIKit

class MallListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addMallButton: UIButton!
    
    private let cellReuseIdentifier = "MallTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        return 20
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
