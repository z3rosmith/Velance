import UIKit

class InputUserInfoForRegister: UIViewController, Storyboarded {
    
    // 나의 채식
    @IBOutlet weak var myVeganTypeView: UIView!
    @IBOutlet weak var veganTypeGuideLabel: UILabel!
    @IBOutlet var veganButtonOuterViews: [UIView]!
    @IBOutlet var veganTypeButtons: [UIButton]!
    @IBOutlet weak var notChooseVeganTypeButton: VLGradientButton!
    
    // 나의 입맛
    @IBOutlet weak var myTasteTypeView: UIView!
    @IBOutlet var tasteOptionButtons: [VLGradientButton]!
    
    // 나의 관심사
    @IBOutlet weak var myInterestView: UIView!
    @IBOutlet var interestOptionButtons: [VLGradientButton]!

    // 나의 식품 특이사항
    @IBOutlet weak var myAllergyView: UIView!
    @IBOutlet var allergyOptionButtons: [VLGradientButton]!
    
    
    //MARK: - Constants
    
    fileprivate struct Metrics {
        
        static let cornerRadius: CGFloat = 15
        static let borderWidth: CGFloat = 0.3
        static let guideStringFontSize: CGFloat = 14
    }
    
    static var storyboardName: String {
        StoryboardName.userRegister
    }

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

}
#warning("ButtonView 에도 터치 넣기")
//MARK: - IBActions

extension InputUserInfoForRegister {
    
    @IBAction func pressedVeganTypeButton(_ sender: UIButton) {
        notChooseVeganTypeButton.isSelected = false
        notChooseVeganTypeButton.setTitleColor(.darkGray, for: .normal)
        notChooseVeganTypeButton.layer.borderColor = UIColor.systemGray3.cgColor
        
        veganTypeButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        veganTypeButtons.forEach { button in
            if button.isSelected {
                veganButtonOuterViews[button.tag].backgroundColor = UIColor(named: Colors.appDefaultColor)
                button.setImage(UIImage(named: Images.veganTypesSelected[button.tag]), for: .normal)
            } else {
                veganButtonOuterViews[button.tag].backgroundColor = .white
                button.setImage(UIImage(named: Images.veganTypesUnselected[button.tag]), for: .normal)
            }
        }
    }
    
    @IBAction func pressedNotChooseVeganTypeButton(_ sender: UIButton) {
        
        veganTypeButtons.forEach { button in
            veganButtonOuterViews[button.tag].backgroundColor = .white
            button.setImage(UIImage(named: Images.veganTypesUnselected[button.tag]), for: .normal)
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
    
    @IBAction func pressedTasteOptionButton(_ sender: UIButton) {
        
        switch sender.isSelected {
        case true:
            sender.isSelected = !sender.isSelected
            sender.setTitleColor(UIColor(named: Colors.tabBarSelectedColor), for: .normal)
        case false:
            sender.isSelected = !sender.isSelected
            sender.setTitleColor(.white, for: .normal)
        }
    }
}

//MARK: - UI Configuration & Initialization

extension InputUserInfoForRegister {
    
    private func configure() {
        title = "회원가입"
        configureLabels()
        configureUIViews()
        configureVeganButtonOuterViews()
        configureNotChooseVeganTypeButton()
        configureTasteOptionButtons()
        configureInterestOptionButtons()
        configureAllergyOptionButtons()
    }
    
    private func configureLabels() {
        veganTypeGuideLabel.attributedText = NSMutableAttributedString()
            .normal("채식 타입을 고를 수 있습니다!\n원치 않을 경우에는 ")
            .bold("선택하지 않으셔도")
            .normal(" 됩니다.")
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
        var index: Int = 0
        tasteOptionButtons.forEach { button in
            button.tag = index
            button.setTitle(UserOptions.tasteOption[index], for: .normal)
            button.layer.borderColor = UIColor(named: Colors.appDefaultColor)?.cgColor
            index += 1
        }
    }
    
    private func configureInterestOptionButtons() {
        var index: Int = 0
        interestOptionButtons.forEach { button in
            button.tag = index
            button.setTitle(UserOptions.interestOptions[index], for: .normal)
            button.layer.borderColor = UIColor(named: Colors.appDefaultColor)?.cgColor
            index += 1
        }
    }
    
    private func configureAllergyOptionButtons() {
        var index: Int = 0
        allergyOptionButtons.forEach { button in
            button.tag = index
            button.setTitle(UserOptions.allergyOptions[index], for: .normal)
            button.layer.borderColor = UIColor(named: Colors.appDefaultColor)?.cgColor
            index += 1
        }
    }
}
