import UIKit

class MyPageViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var vegetarianTypeLabel: UILabel!
    @IBOutlet weak var myPageTableView: UITableView!
    
    fileprivate struct Images {
        static let myPageCellImageNames: [String] = ["person.fill", "scroll.fill", "exclamationmark.triangle.fill", "power.circle.fill"]
    }
    
    fileprivate struct Texts {
        static let myPageCellTitle: [String] = ["내 정보 수정", "서비스 이용약관", "개인정보 처리방침", "로그아웃"]
    }
    
    fileprivate struct SegueId {
        static let goToProfileEdit = "goToProfileEdit"
    }
    
    static var storyboardName: String {
        StoryboardName.myPage
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchUserProfileInfo()
    }

}

//MARK: - IBActions & Target Methods

extension MyPageViewController {
    
    func fetchUserProfileInfo() {
        
        UserManager.shared.fetchProfileInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                
                DispatchQueue.main.async {
                    self.nicknameLabel.text = User.shared.displayName
                    self.vegetarianTypeLabel.text = User.shared.vegetarianType
                }
                
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
        
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
        
        switch indexPath.row {
        case 0:
            let storyboard = UIStoryboard(name: StoryboardName.userRegister, bundle: nil)
            guard let vc = storyboard.instantiateViewController(
                withIdentifier: "InputUserInfoForRegisterViewController"
            ) as? InputUserInfoForRegisterViewController else { return }

            navigationController?.pushViewController(vc, animated: true)
        case 1: break
        case 2: break
        case 3:
            presentAlertWithConfirmAction(title: "로그아웃 하시겠습니까?", message: "") { selectedOk in
                if selectedOk { self.popToLoginViewController() }
            }
        default: break
        }
    }
}

//MARK: - UI Configuration & Initialization

extension MyPageViewController {
    
    private func configure() {
        setNavBarBackButtonItemTitle()
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
