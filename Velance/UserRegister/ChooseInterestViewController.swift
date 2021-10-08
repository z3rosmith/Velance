import UIKit

class ChooseInterestViewController: UIViewController, Storyboarded {
    
    // 나의 채식
    @IBOutlet weak var myVeganTypeView: UIView!
    @IBOutlet weak var veganTypeGuideLabel: UILabel!
    @IBOutlet var veganButtonOuterViews: [UIView]!
    @IBOutlet var veganTypeButtons: [UIButton]!
    
    // 나의 입맛
    @IBOutlet weak var myTasteTypeView: UIView!
    @IBOutlet var tasteOptionButtons: [VLTypeOptionButton]!
    
    // 나의 관심사
    @IBOutlet weak var myInterestView: UIView!
    @IBOutlet var interestOptionButtons: [VLTypeOptionButton]!
    
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

//MARK: - IBActions

extension ChooseInterestViewController {
    
    @IBAction func pressedVeganTypeButton(_ sender: UIButton) {
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
    
    @IBAction func pressedTasteOptionButton(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? !sender.isSelected : !sender.isSelected
    }
}

//MARK: - UI Configuration & Initialization

extension ChooseInterestViewController {
    
    private func configure() {
        title = "회원가입"
        configureLabels()
        configureUIViews()
        configureButtonOuterViews()
        configureTasteOptionButtons()
        configureInterestOptionButtons()
        
    }
    
    private func configureLabels() {

        veganTypeGuideLabel.attributedText = NSMutableAttributedString()
            .normal("채식 타입을 고를 수 있습니다!\n원치 않을 경우에는 ")
            .bold("선택하지 않으셔도")
            .normal(" 됩니다.")

    }
    
    private func configureUIViews() {
        [myVeganTypeView, myTasteTypeView, myInterestView].forEach { view in
            view?.backgroundColor = .white
            view?.layer.cornerRadius = Metrics.cornerRadius
        }
    }
    
    private func configureButtonOuterViews() {
        veganButtonOuterViews.forEach { view in
            view.layer.cornerRadius = view.frame.height / 2
            view.layer.borderWidth = Metrics.borderWidth
            view.layer.borderColor = UIColor(named: Colors.appDefaultColor)?.cgColor
        }
    }
    

    
    private func configureTasteOptionButtons() {
        var index: Int = 0
        tasteOptionButtons.forEach { button in
            button.tag = index
            button.setTitle(UserOptions.tasteOption[index], for: .normal)
            index += 1
        }
    }
    
    private func configureInterestOptionButtons() {
        var index: Int = 0
        interestOptionButtons.forEach { button in
            button.tag = index
            button.setTitle(UserOptions.interestOptions[index], for: .normal)
            index += 1
        }
    }
    

    
}
