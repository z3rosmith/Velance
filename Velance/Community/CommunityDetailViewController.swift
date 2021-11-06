import UIKit
import InputBarAccessoryView
import SnapKit

class CommunityDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputBar: VelanceInputBar!
    
    private lazy var tableHeaderView: CommunityDetailTableHeaderView = {
        let headerView = CommunityDetailTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 500))
        headerView.parentVC = self
        headerView.commentButton.isSelected = true
        tableView.tableHeaderView = headerView
        return headerView
    }()
    
    private let cellReuseIdentifier = "CommunityDetailTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupTableHeaderView()
        setupInputBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // tableHeaderView Dynamic Height
        let size = tableHeaderView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if tableHeaderView.frame.size.height != size.height {
            tableHeaderView.frame.size.height = size.height
            tableView.tableHeaderView = tableHeaderView
            tableView.layoutIfNeeded()
        }
    }
}

extension CommunityDetailViewController {
    
    private func setupInputBar() {
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = .default
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CommunityDetailTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    private func setupTableHeaderView() {
        tableHeaderView.contentLabel.text = "오늘 방문한 수성구 비건 식당입니다! 가격도 괜찮고 페스코 여러분께 추천드리는 식당입니다! 한 번 들러보시면 좋을 것 같아요 ㅎㅎ\n오늘 방문한 수성구 비건 식당입니다! 가격도 괜찮고 페스코 여러분께 추"
        tableHeaderView.likeButton.setRightText(text: "143")
        tableHeaderView.commentButton.setRightText(text: "5")
    }
    
    @objc private func didTapMoreButton(_ sender: UIButton) {
        print("moreButton Tapped.")
    }
}

extension CommunityDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension CommunityDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? CommunityDetailTableViewCell else { fatalError() }
        cell.moreButton.tag = indexPath.row
        cell.moreButton.addTarget(self, action: #selector(didTapMoreButton(_:)), for: .touchUpInside)
        if indexPath.row == 0 {
            cell.contentLabel.text = "멋지네요! 저도 방문해보고싶어요 :)"
        } else if indexPath.row == 1 {
            cell.contentLabel.text = "와 얼마인가요? 완전 좋아요 비건 식당이 더욱 다양해졌으면 좋겠어요"
        }
        return cell
    }
}

extension CommunityDetailViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        inputBar.inputTextView.resignFirstResponder()
    }
}
