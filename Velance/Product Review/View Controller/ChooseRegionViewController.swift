import UIKit

protocol ChooseRegionDelegate: AnyObject {
    func didChooseRegion()
}

class ChooseRegionViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chooseRegionContainerView: UIView!
    @IBOutlet var regionOptionButtons: [VLGradientButton]!
    
    @IBOutlet weak var doneButton: UIButton!
    
    private var selectedRegionTypeId: Int = 1
    
    weak var delegate: ChooseRegionDelegate?
    
    static var storyboardName: String {
        StoryboardName.productReview
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

//MARK: - IBActions & Target Methods

extension ChooseRegionViewController {
    
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
    
    @objc private func pressedDoneButton() {
        print("✏️ pressedDoneButton")
        regionOptionButtons.forEach { button in
            if button.isSelected {
                selectedRegionTypeId = button.tag
            }
        }
        delegate?.didChooseRegion()
        dismiss(animated: true)
    }
}


//MARK: - Initialization & Configuration

extension ChooseRegionViewController {
    
    private func configure() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configureContainerView()
        configureRegionOptionButtons()
        configureChooseOptionContainerView()
        configureDoneButton()
    }
    
    private func configureContainerView() {
        containerView.layer.cornerRadius = 30
    }
    
    private func configureRegionOptionButtons() {
        var index: Int = 1
        regionOptionButtons.forEach { button in
            button.tag = index
            button.backgroundColor = .white
            button.setTitle(UserOptions.regionOptions[index - 1], for: .normal)
            button.layer.borderColor = UIColor(named: Colors.appDefaultColor)?.cgColor
            index += 1
        }
    }
    
    private func configureChooseOptionContainerView() {
        chooseRegionContainerView.layer.cornerRadius = 15
        chooseRegionContainerView.layer.borderWidth = 0.3
    }
    

    private func configureDoneButton() {
        doneButton.addTarget(
            self,
            action: #selector(pressedDoneButton),
            for: .touchUpInside
        )
    }
}
