import UIKit

class MyPageViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var myPageTableView: UITableView!
    
    fileprivate struct Images {
        static let myPageCellImageNames: [String] = ["person.fill", "scroll.fill", "exclamationmark.triangle.fill"]
    }
    
    fileprivate struct Texts {
        static let myPageCellTitle: [String] = ["내 정보 수정", "서비스 이용약관", "개인정보 처리방침"]
    }
    
    static var storyboardName: String {
        StoryboardName.myPage
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

    }

}

//MARK: - IBActions & Target Methods

extension MyPageViewController {
    
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MyPageTableViewCell",
            for: indexPath
        ) as? MyPageTableViewCell else { return UITableViewCell() }
        
        cell.leftImageView.image = UIImage(systemName: Images.myPageCellImageNames[indexPath.row])
        cell.titleLabel.text = Texts.myPageCellTitle[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UI Configuration & Initialization

extension MyPageViewController {
    
    private func configure() {
        
        configureMyPageTableView()
    }
    
    private func configureMyPageTableView() {
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
        
        let myPageTableViewCell = UINib(nibName: "MyPageTableViewCell", bundle: nil)
        
        myPageTableView.register(
            myPageTableViewCell,
            forCellReuseIdentifier: "MyPageTableViewCell"
        )
        myPageTableView.rowHeight = UITableView.automaticDimension
        myPageTableView.estimatedRowHeight = 80
        myPageTableView.separatorStyle = .none
    }
}
