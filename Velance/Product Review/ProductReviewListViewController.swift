import UIKit

class ProductReviewListViewController: UIViewController, Storyboarded { 
    
    @IBOutlet weak var filterAllergyButton: UIButton!
    @IBOutlet weak var filterVeganTypeButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
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
    

}

extension ProductReviewListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
            
        return cell
    }
    
    
}

//MARK: - Initialization & UI Configuration

extension ProductReviewListViewController {
    
    private func configure() {
      
        
        tableView.dataSource = self

    }
    

    
//    private func configureFilterButtons() {
//        [filterAllergyButton, filterVeganTypeButton].forEach { button in
//            button?.isUserInteractionEnabled = true
//            button?.addTarget(self, action: #selector(pressedFilter), for: .touchUpInside)
//        }
//
//    }
    
    
}
