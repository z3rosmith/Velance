import UIKit

class ChooseInterestViewController: UIViewController, Storyboarded {
    
    // 나의 채식
    @IBOutlet weak var myVeganTypeView: UIView!
    @IBOutlet var veganButtonOuterViews: [UIView]!
    @IBOutlet var veganTypeButtons: [UIButton]!
    
    // 나의 입맛
    @IBOutlet weak var myTasteTypeView: UIView!
    @IBOutlet var tasteOptionButtons: [VLTypeOptionButton]!
    
    // 나의 관심사
    @IBOutlet weak var myInterestView: UIView!
    
    private var selectedVeganTypeIndex: Int = 0


    fileprivate struct UserOptions {
        
        static let veganType: [String] = ["비건", "오보", "락토", "락토/오보", "페스코"]
        static let tasteOption: [String] = ["짭잘한", "매콤한", "느끼한",
                                            "달달한", "깔끔한", "심심한",
                                            "새콤달콤", "크리미한", "단짠단짠",
                                            "한식풍의", "이국적인", "탕류",
                                            "구이류", "볶음류", "면류", "빵/디저트"]
    }

    
    static var storyboardName: String {
        StoryboardName.userRegister
    }

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
        configureUIViews()
        configureButtonOuterViews()
        configureTasteOptionButtons()
    }
    
    private func configureUIViews() {
        [myVeganTypeView, myTasteTypeView, myInterestView].forEach { view in
            view?.backgroundColor = .white
            view?.layer.cornerRadius = 15
        }
    }
    
    private func configureButtonOuterViews() {
        veganButtonOuterViews.forEach { view in
            view.layer.cornerRadius = view.frame.height / 2
            view.layer.borderWidth = 0.3
            view.layer.borderColor = UIColor(named: Colors.appDefaultColor)?.cgColor
        }
    }
    
    private func configureTasteOptionButtons() {
        tasteOptionButtons.forEach { button in
            button.setTitle(UserOptions.tasteOption[button.tag], for: .normal)
        }
        
    }
    

    
    
}
