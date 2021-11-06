import UIKit

protocol ChooseRegionDelegate: AnyObject {
    func didChooseRegion(region: Int)
}

class ChooseRegionViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chooseRegionContainerView: UIView!
    @IBOutlet var regionOptionButtons: [VLGradientButton]!
    
    @IBOutlet weak var doneButton: UIButton!
    
    private var selectedRegionTypeId: Int = 1
    
    weak var delegate: ChooseRegionDelegate?
    
    static var storyboardName: String {
        StoryboardName.community
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

//MARK: - IBActions & Target Methods

extension ChooseRegionViewController {
    
    @IBAction func pressedOptionButton(_ sender: UIButton) {
        regionOptionButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        selectedRegionTypeId = sender.tag
    }
    
    @objc private func pressedDoneButton() {
        delegate?.didChooseRegion(region: selectedRegionTypeId)
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
        chooseRegionContainerView.layer.borderWidth = 0.2
    }
    

    private func configureDoneButton() {
        doneButton.addTarget(
            self,
            action: #selector(pressedDoneButton),
            for: .touchUpInside
        )
    }
}
