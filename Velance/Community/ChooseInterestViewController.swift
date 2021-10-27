import UIKit

protocol ChooseInterestDelegate: AnyObject {
    func didSelectInterestOptions()
}

class ChooseInterestViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chooseOptionContainerView: UIView!
    @IBOutlet var interestOptionButtons: [VLGradientButton]!
    
    // 선택 완료 버튼
    @IBOutlet weak var doneButtonImageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: ChooseInterestDelegate?
    
    static var storyboardName: String {
        StoryboardName.community
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}
//MARK: - IBActions & Target Methods

extension ChooseInterestViewController {
    
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
        delegate?.didSelectInterestOptions()
        dismiss(animated: true)
    }
}

//MARK: - Initialization & Configuration

extension ChooseInterestViewController {
    
    private func configure() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        configureContainerView()
        configureInterestOptionButtons()
        configureChooseOptionContainerView()
        
        configureDoneButton()
    }
    
    private func configureContainerView() {
        containerView.layer.cornerRadius = 30
    }
    
    private func configureInterestOptionButtons() {
        var index: Int = 0
        interestOptionButtons.forEach { button in
            button.tag = index
            button.backgroundColor = .white
            button.setTitle(UserOptions.interestOptions[index], for: .normal)
            button.layer.borderColor = UIColor(named: Colors.appDefaultColor)?.cgColor
            index += 1
        }
    }
    
    private func configureChooseOptionContainerView() {
        chooseOptionContainerView.layer.cornerRadius = 15
        chooseOptionContainerView.layer.borderWidth = 0.3
    }
    

    private func configureDoneButton() {
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(pressedDoneButton)
        )
        doneButtonImageView.addGestureRecognizer(tapGesture)
        
        doneButton.addTarget(
            self,
            action: #selector(pressedDoneButton),
            for: .touchUpInside
        )
    }
    
}
