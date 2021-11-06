import UIKit

class MyPageViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var vegetarianTypeLabel: UILabel!
    @IBOutlet weak var myPageTableView: UITableView!
    
    fileprivate struct Images {
        static let myPageCellImageNames: [String] = ["person.fill", "scroll.fill", "exclamationmark.triangle.fill", "power.circle.fill", "person.crop.circle.fill.badge.xmark"]
    }
    
    fileprivate struct Texts {
        static let myPageCellTitle: [String] = ["내 정보 수정", "서비스 이용약관", "개인정보 처리방침", "로그아웃", "회원 탈퇴"]
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
    
    func unregisterUser() {
        showProgressBar()
        UserManager.shared.unregisterUser { [weak self] result in
            dismissProgressBar()
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async { self.popToLoginViewController() }
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
            
        }
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
            guard let vc = InputUserInfoForRegisterViewController.instantiate() as? InputUserInfoForRegisterViewController else { return }
            vc.isForEditingUser = true
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let url = URL(string: NotionUrl.termsAndAgreementUrl)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case 2:
            let url = URL(string: NotionUrl.privacyTermsUrl)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case 3:
            presentAlertWithConfirmAction(title: "로그아웃 하시겠습니까?", message: "") { selectedOk in
                if selectedOk { self.popToLoginViewController() }
            }
        case 4:
            presentAlertWithConfirmAction(title: "정말 회원 탈퇴를 하시겠습니까?", message: "회원 탈퇴를 하면 내가 작성한 모든 글이 사라지고, 복구할 수 없어요. 그래도 진행하시겠습니까?") { selectedOk in
                if selectedOk { self.unregisterUser() }
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
