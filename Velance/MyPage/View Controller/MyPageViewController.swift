import UIKit
import SDWebImage

class MyPageViewController: UIViewController, Storyboarded {
    
    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var vegetarianTypeLabel: UILabel!
    @IBOutlet weak var myPageTableView: UITableView!
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .savedPhotosAlbum
        return imagePicker
    }()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUserProfileInfo()
    }

}

//MARK: - IBActions & Target Methods

extension MyPageViewController {
    
    func fetchUserProfileInfo() {
        
        UserManager.shared.fetchProfileInfo { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userModel):
                
                DispatchQueue.main.async {
                    self.nicknameLabel.text = User.shared.displayName
                    self.vegetarianTypeLabel.text = User.shared.vegetarianType
                    
                    self.profileImageButton.sd_setImage(
                        with: URL(string: userModel.fileFolder?.files[0].path ?? ""),
                        for: .normal,
                        placeholderImage: UIImage(named: "MyPageProfileImageButton")
                    )
                    self.profileImageButton.layer.masksToBounds = userModel.fileFolder != nil
                    ? true
                    : false
                }
                
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
    }
    
    @IBAction func pressedProfileImageButton(_ sender: UIButton) {
        presentActionSheet()
    }
    
    func presentActionSheet() {

        let library = UIAlertAction(
            title: "앨범에서 선택",
            style: .default
        ) { [weak self] _ in
            guard let self = self else { return }
            self.present(self.imagePicker, animated: true)
        }
        let remove = UIAlertAction(
            title: "프로필 사진 제거",
            style: .default
        ) { [weak self] _ in
            self?.presentAlertWithConfirmAction(
                title: "프로필 사진 제거",
                message: "정말로 제거하시겠습니까?"
            ) { selectedOk in
                if selectedOk { self?.removeProfileImage() }
            }
        }

        
        let actionSheet = UIHelper.createActionSheet(with: [library, remove], title: "프로필 사진 변경" )
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    func removeProfileImage() {
        UserManager.shared.removeUserProfileImage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.showSimpleBottomAlert(with: "프로필 이미지 제거 성공 🎉")
                self.fetchUserProfileInfo()
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
    }
    
    func updateProfileImage(imageData: Data) {
        
        UserManager.shared.updateUserProfileImage(imageData: imageData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.showSimpleBottomAlert(with: "프로필 이미지 변경 성공 🎉")
                self.fetchUserProfileInfo()
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

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MyPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            dismiss(animated: true) {
                self.presentAlertWithConfirmAction(
                    title: "프로필 사진 변경",
                    message: "선택하신 이미지로 프로필 사진을 변경하시겠습니까?"
                ) { selectedOk in
                    if selectedOk {
                        showProgressBar()
                        OperationQueue().addOperation {
                            guard let imageData = originalImage.jpegData(compressionQuality: 0.9) else {
                                return
                            }
                            self.updateProfileImage(imageData: imageData)
                            dismissProgressBar()
                        }
                    } else {
                        self.imagePickerControllerDidCancel(self.imagePicker)
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

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
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.tintColor = .white
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor(named: Colors.appDefaultColor)
            navController.navigationBar.standardAppearance = appearance
            navController.navigationBar.scrollEdgeAppearance = appearance
            present(navController, animated: true)
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
        configureProfileImageButton()
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
    
    private func configureProfileImageButton() {
        profileImageButton.layer.cornerRadius = profileImageButton.frame.height / 2
        profileImageButton.layer.masksToBounds = false
        profileImageButton.contentMode = .scaleAspectFit
    }
}
