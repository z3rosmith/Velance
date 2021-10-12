//import UIKit
//
//class ChooseDetailViewController: UIViewController {
//    
//    @IBOutlet weak var bottomView: VLBottomView!
//    
//    @IBOutlet weak var heightSlider: UISlider!
//    @IBOutlet weak var weightSlider: UISlider!
//    
//    @IBOutlet weak var heightLabel: UILabel!
//    @IBOutlet weak var weightLabel: UILabel!
//    
//    @IBOutlet var genderButtons: [UIButton]!
//    
//    private var selectedGenderIndex: Int = 0
//    private var didSelectGender: Bool = false
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configure()
//    }
//    
//    @IBAction func pressedPreviousButton(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @IBAction func pressedNextButton(_ sender: UIButton) {
//        
//        if !didSelectGender {
//            presentVLAlert(title: "성별 선택", message: "성별을 선택해주세요.", buttonTitle: "확인")
//            return
//        }
//        
//        UserRegisterValues.shared.height = Int(heightSlider.value)
//        UserRegisterValues.shared.weight = Int(weightSlider.value)
//        UserRegisterValues.shared.gender = selectedGenderIndex
//        
//        guard let vc = storyboard?.instantiateViewController(
//            identifier: StoryboardID.chooseReasonVC
//        ) as? ChooseReasonViewController else { fatalError() }
//        
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    @IBAction func heightSliderValueChanged(_ sender: UISlider) {
//        let value = Int(sender.value)
//        heightLabel.text = String(value) + "cm"
//    }
//    
//    @IBAction func weightSliderValueChange(_ sender: UISlider) {
//        let value = Int(sender.value)
//        weightLabel.text = String(value) + "kg"
//        
//    }
//    
//    @IBAction func pressedGenderButton(_ sender: UIButton) {
//        
//        didSelectGender = true
//        
//        genderButtons[selectedGenderIndex].backgroundColor = UIColor(named: Colors.appTintColor)
//        genderButtons[selectedGenderIndex].setTitleColor(UIColor(named: Colors.buttonSelectedColor), for: .normal)
//        
//        selectedGenderIndex = sender.tag
//        
//        genderButtons[selectedGenderIndex].backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7254901961, blue: 0.2235294118, alpha: 1)
//        genderButtons[selectedGenderIndex].setTitleColor(.white, for: .normal)
//        
//    }
//    
//}
//
////MARK: - UI Configuration
//
//extension ChooseDetailViewController {
//    
//    private func configure() {
////        configureBottomView()
//        configureGenderButtons()
//    }
//    
//    private func configureBottomView() {
//        bottomView.layer.cornerRadius = 30
//        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//    }
//    
//    private func configureGenderButtons() {
//        genderButtons.forEach { button in
//            button.layer.cornerRadius = button.frame.height / 2
//        }
//    }
//}
