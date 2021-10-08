import UIKit

class ChooseInterestViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var myVeganTypeView: UIView!
    @IBOutlet weak var myTasteTypeView: UIView!
    @IBOutlet var veganButtonOuterViews: [UIView]!
    @IBOutlet var veganTypeButtons: [UIButton]!
    @IBOutlet var tasteOptionButtons: [UIButton]!

    
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
        
        print("✏️ tag: \(sender.tag)")
    }
    
    @IBAction func pressedTasteOptionButton(_ sender: UIButton) {
        
        switch sender.isSelected {
        case true:
            sender.isSelected = !sender.isSelected
//            sender.removeGradient(sender, layerIndex: 1)
            sender.setTitleColor(UIColor(named: Colors.tabBarSelectedColor), for: .normal)

        case false:
            sender.isSelected = !sender.isSelected
            sender.applyGradient(with: [UIColor(named: Colors.ovalButtonGradientLeft)!,
                                        UIColor(named: Colors.ovalButtonGradientRight)!])
            sender.setTitleColor(.white, for: .normal)

            
        }
        
   

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
        [myVeganTypeView, myTasteTypeView].forEach { view in
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
            button.layer.borderWidth = 0.3
            button.layer.borderColor = UIColor(named: Colors.appDefaultColor)?.cgColor
            button.layer.cornerRadius = button.frame.height / 2
            button.setTitle(UserOptions.tasteOption[button.tag], for: .normal)
          
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.8
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            button.isSelected = false
        }
        
    }
    

    
    
}
