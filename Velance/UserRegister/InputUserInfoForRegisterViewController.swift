import UIKit

class InputUserInfoForRegisterViewController: UIViewController, Storyboarded {
    
    //MARK: - IBOutlets
    
    // 나의 채식
    @IBOutlet weak var myVeganTypeView: UIView!
    @IBOutlet weak var veganTypeGuideLabel: UILabel!
    @IBOutlet var veganButtonOuterViews: [UIView]!
    @IBOutlet var veganTypeButtons: [UIButton]!
    @IBOutlet weak var notChooseVeganTypeButton: VLGradientButton!
    
    // 나의 입맛
    @IBOutlet weak var myTasteTypeView: UIView!
    @IBOutlet var tasteTypeGuideLabel: UILabel!
    @IBOutlet var tasteOptionButtons: [VLGradientButton]!
    
    // 나의 관심사
    @IBOutlet weak var myInterestView: UIView!
    @IBOutlet var interestOptionButtons: [VLGradientButton]!

    // 나의 식품 특이사항
    @IBOutlet weak var myAllergyView: UIView!
    @IBOutlet var allergyOptionButtons: [VLGradientButton]!
    
    @IBOutlet var termsGuideStackView: UIStackView!
    
    @IBOutlet var doneButton: UIButton!
    
    var isForEditingUser: Bool!
    
    //MARK: - Constants
    
    fileprivate struct Metrics {
        
        static let cornerRadius: CGFloat = 15
        static let borderWidth: CGFloat = 0.3
        static let guideStringFontSize: CGFloat = 14
    }
    
    static var storyboardName: String {
        StoryboardName.userRegister
    }
    
    
    //MARK: - Properties
    
    private var veganTypeId: String = ""
    private var tasteTypeIds: [String] = []
    private var interestTypeIds: [String] = []
    private var allergyTypeIds: [String] = []

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}
//MARK: - IBActions

extension InputUserInfoForRegisterViewController {
    
    @IBAction func pressedVeganTypeButton(_ sender: UIButton) {
        notChooseVeganTypeButton.isSelected = false
        notChooseVeganTypeButton.setTitleColor(.darkGray, for: .normal)
        notChooseVeganTypeButton.layer.borderColor = UIColor.systemGray3.cgColor
        
        veganTypeButtons.forEach { $0.isSelected = false }
        
        sender.isSelected = true
        veganTypeId = String(sender.tag)
        
        veganTypeButtons.forEach { button in
            if button.isSelected {
                veganButtonOuterViews[button.tag - 1].backgroundColor = UIColor(named: Colors.appDefaultColor)
                button.setImage(UIImage(named: Images.veganTypesSelected[button.tag - 1]), for: .normal)
            } else {
                veganButtonOuterViews[button.tag - 1].backgroundColor = .white
                button.setImage(UIImage(named: Images.veganTypesUnselected[button.tag - 1]), for: .normal)
            }
        }
    }
    
    @IBAction func pressedNotChooseVeganTypeButton(_ sender: UIButton) {
        
        veganTypeButtons.forEach { button in
            veganButtonOuterViews[button.tag - 1].backgroundColor = .white
            button.setImage(UIImage(named: Images.veganTypesUnselected[button.tag - 1]), for: .normal)
        }
        
        switch sender.isSelected {
        case true:
            sender.isSelected = !sender.isSelected
            sender.setTitleColor(.darkGray, for: .normal)
            sender.layer.borderColor = UIColor.systemGray3.cgColor
        case false:
            sender.isSelected = !sender.isSelected
            sender.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func pressedOptionButton(_ sender: UIButton) {
        
        switch sender.isSelected {
        case true:
            sender.isSelected = !sender.isSelected
            sender.setTitleColor(UIColor(named: Colors.tabBarSelectedColor), for: .normal)
        case false:
            sender.isSelected = !sender.isSelected
            sender.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
        
        tasteTypeIds.removeAll()
        interestTypeIds.removeAll()
        allergyTypeIds.removeAll()
        
        tasteOptionButtons.forEach { button in
            if button.isSelected {
                tasteTypeIds.append(String(button.tag))
            }
        }
        
        interestOptionButtons.forEach { button in
            if button.isSelected {
                interestTypeIds.append(String(button.tag))
            }
        }
        allergyOptionButtons.forEach { button in
            if button.isSelected {
                allergyTypeIds.append(String(button.tag))
            }
        }
        
        // Validation
        
        if tasteTypeIds.count < 5 {
            showSimpleBottomAlert(with: "나의 입맛을 5가지 이상 골라주세요.")
            return
        } else if interestOptionButtons.count < 3 {
            showSimpleBottomAlert(with: "나의 관심사를 3가지 이상 골라주세요.")
            return
        }
        
        presentAlertWithConfirmAction(
            title: isForEditingUser ? "회원 정보를 수정하시겠습니까?" : "회원가입 하시겠습니까?",
            message: ""
        ) { [weak self] selectedOk in
            guard let self = self else { return }
            if selectedOk {
                self.isForEditingUser
                ? self.updateUserInfo()
                : self.proceedRegisterProcess()
            }
        }
    }
    
    private func updateUserInfo() {
        
        let model = UserInfoUpdateDTO(
            vegetarianTypeId: veganTypeId,
            tasteTypeIds: tasteTypeIds,
            interestTypeIds: interestTypeIds,
            allergyTypeIds: allergyTypeIds
        )
        
        UserManager.shared.updateUserInfo(with: model) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.showSimpleBottomAlert(with: "프로필 변경 성공 🎉")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
    }
    
    private func proceedRegisterProcess() {
        UserRegisterValues.shared.vegetarianTypeId = veganTypeId
        UserRegisterValues.shared.tasteTypeIds = tasteTypeIds
        UserRegisterValues.shared.interestTypeIds = interestTypeIds
        UserRegisterValues.shared.allergyTypeIds = allergyTypeIds
        
        let vc = LoadingViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func pressedGoSeeTermsAndServiceButton(_ sender: UIButton) {
        let url = URL(string: NotionUrl.termsAndAgreementUrl)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func pressedGoSeePrivacyTermsButton(_ sender: UIButton) {
        let url = URL(string: NotionUrl.privacyTermsUrl)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc private func pressedSettingsButton() {
        let vc = ChangePasswordViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - UI Configuration & Initialization

extension InputUserInfoForRegisterViewController {
    
    private func configure() {
        title = isForEditingUser ? "내 정보 수정" : "내 정보 입력"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        configureLabels()
        configureUIViews()
        configureVeganButtonOuterViews()
        configureNotChooseVeganTypeButton()
        configureTasteOptionButtons()
        configureInterestOptionButtons()
        configureAllergyOptionButtons()
        configureDoneButton()
        configureTermsGuideStackView()
        
        if isForEditingUser {
            let settingsBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "gearshape"),
                style: .plain,
                target: self,
                action: #selector(pressedSettingsButton)
            )
            
            let dismissBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "xmark"),
                style: .plain,
                target: self,
                action: #selector(dismissVC)
            )
            navigationItem.rightBarButtonItem = settingsBarButtonItem
            navigationItem.leftBarButtonItem = dismissBarButtonItem
          
        }
        
    }
    
    private func configureLabels() {
        veganTypeGuideLabel.attributedText = NSMutableAttributedString()
            .normal("채식 타입을 고를 수 있습니다!\n원치 않을 경우에는 ")
            .bold("선택하지 않으셔도")
            .normal(" 됩니다.")
        
        tasteTypeGuideLabel.attributedText = NSMutableAttributedString()
            .normal("당신이 좋아하는 스타일의 맛을 ")
            .bold("5가지 ")
            .normal("골라주세요!\n서비스에 당신의 취향이 반영됩니다.")
    }
    
    private func configureUIViews() {
        [myVeganTypeView, myTasteTypeView, myInterestView, myAllergyView].forEach { view in
            view?.backgroundColor = .white
            view?.layer.cornerRadius = Metrics.cornerRadius
        }
    }
    
    private func configureVeganButtonOuterViews() {
        veganButtonOuterViews.forEach { view in
            view.layer.cornerRadius = view.frame.height / 2
            view.layer.borderWidth = Metrics.borderWidth
            view.layer.borderColor = UIColor(named: Colors.appDefaultColor)?.cgColor
        }
    }
    
    private func configureNotChooseVeganTypeButton() {
        notChooseVeganTypeButton.layer.cornerRadius = notChooseVeganTypeButton.frame.height / 2
        notChooseVeganTypeButton.layer.borderWidth = 1
        notChooseVeganTypeButton.layer.borderColor = UIColor.systemGray3.cgColor
        notChooseVeganTypeButton.backgroundColor = UIColor.systemGray6
    }
    
    private func configureTasteOptionButtons() {
        var index: Int = 1
        tasteOptionButtons.forEach { button in
            button.tag = index
            button.setTitle(UserOptions.tasteOption[index - 1], for: .normal)
            button.layer.borderColor = UIColor(named: Colors.appDefaultColor)?.cgColor
            index += 1
        }
    }
    
    private func configureInterestOptionButtons() {
        var index: Int = 1
        interestOptionButtons.forEach { button in
            button.tag = index
            button.setTitle(UserOptions.interestOptions[index - 1], for: .normal)
            button.layer.borderColor = UIColor(named: Colors.appDefaultColor)?.cgColor
            index += 1
        }
    }
    
    private func configureAllergyOptionButtons() {
        var index: Int = 1
        allergyOptionButtons.forEach { button in
            button.tag = index
            button.setTitle(UserOptions.allergyOptions[index - 1], for: .normal)
            button.layer.borderColor = UIColor(named: Colors.appDefaultColor)?.cgColor
            index += 1
        }
    }
    
    private func configureDoneButton() {
        doneButton.setTitle(isForEditingUser ? "정보 수정 완료" : "회원가입 완료!", for: .normal)
    }
    
    private func configureTermsGuideStackView() {
        termsGuideStackView.isHidden = isForEditingUser ? true : false
    }
}
