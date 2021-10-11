import UIKit

class ProductReviewListViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var filterAllergyButton: UIButton!
    @IBOutlet weak var filterVeganTypeButton: UIButton!
    
    static var storyboardName: String {
        StoryboardName.productReview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

//MARK: - @IBActions

extension ProductReviewListViewController {
    
    @IBAction func pressedFilterOption(_ sender: UIButton) {
        print("✏️ pressedFilterOption")
        sender.isSelected.toggle()
    }

    @objc func pressedFilter() {
        print("✏️ pressedFilter")
        
    }
}

//MARK: - Initialization & UI Configuration

extension ProductReviewListViewController {
    
    private func configure() {
        configureFilterButtons()
    }
    
    private func configureFilterButtons() {
        [filterAllergyButton, filterVeganTypeButton].forEach { button in
            button?.addTarget(self, action: #selector(pressedFilter), for: .touchUpInside)
        }
        
    }
    
    
}
