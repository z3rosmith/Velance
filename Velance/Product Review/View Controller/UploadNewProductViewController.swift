import UIKit
import TextFieldEffects

class UploadNewProductViewController: UIViewController, Storyboarded {
    
    
    
    
    

    static var storyboardName: String {
        StoryboardName.productReview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}

//MARK: - IBActions & Target Methods

extension UploadNewProductViewController {
    
    
}



//MARK: - Initialization & UI Configuration

extension UploadNewProductViewController {
    
    private func configure() {
        title = "새 제품 등록"
        
    }
}
