import UIKit
import TextFieldEffects

class UploadNewProductViewController: UIViewController, Storyboarded {

    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productNameTextField: HoshiTextField!
    @IBOutlet weak var productPriceTextField: HoshiTextField!
    
    @IBOutlet weak var chooseVeganTypeView: UIView!
    @IBOutlet var veganTypeButtons: [VLGradientButton]!
    
    @IBOutlet weak var chooseProductCategoryView: UIView!
    @IBOutlet var productCategoryButtons: [VLGradientButton]!
    
    @IBOutlet weak var doneButton: UIButton!
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .savedPhotosAlbum
        return imagePicker
    }()
    
    static var storyboardName: String {
        StoryboardName.productReview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        


    }
    

}

//MARK: - IBActions & Target Methods

extension UploadNewProductViewController {
    
    @IBAction func pressedAddImageButton(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func pressedVeganTypeButton(_ sender: UIButton) {
        switch sender.isSelected {
        case true:
            sender.isSelected = !sender.isSelected
            sender.setTitleColor(UIColor(named: Colors.tabBarSelectedColor), for: .normal)
        case false:
            sender.isSelected = !sender.isSelected
            sender.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func pressedProductCategoryButton(_ sender: UIButton) {
        productCategoryButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
    }
    
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
        print("✏️ pressedDoneButton")
    }
    
    
}


//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension UploadNewProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            dismiss(animated: true) {
                DispatchQueue.main.async {
                    self.productImageView.image = originalImage
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


//MARK: - Initialization & UI Configuration

extension UploadNewProductViewController {
    
    private func configure() {
        title = "새 제품 등록"
        configureAddImageButton()
        configureProductImageView()
        configureTextFields()
        configureUIViews()
        configureVeganTypeGradientButtons()
        configureProductCategoryGradientButtons()
        
    }
    
    private func configureAddImageButton() {
        addImageButton.layer.borderWidth = 1
        addImageButton.layer.borderColor = UIColor.lightGray.cgColor
        addImageButton.layer.cornerRadius = 5
    }
    
    private func configureProductImageView() {
        productImageView.layer.cornerRadius = 5
        productImageView.contentMode = .scaleAspectFill
    } 
    
    private func configureTextFields() {
        
    }
    
    private func configureUIViews() {
        
        [chooseVeganTypeView, chooseProductCategoryView].forEach { view in
            guard let view = view else { return }
            view.layer.cornerRadius = 15
            view.layer.borderWidth = 0.3
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.backgroundColor = UIColor(named: Colors.appBackgroundColor)
            
        }
    }
    
    private func configureVeganTypeGradientButtons() {
        var index: Int = 0
        veganTypeButtons.forEach { button in
            button.tag = index
            button.setTitle(UserOptions.veganType[index], for: .normal)
            index += 1
        }
        
    }
    
    private func configureProductCategoryGradientButtons() {
        var index: Int = 0
        productCategoryButtons.forEach { button in
            button.tag = index
            button.setTitle(UserOptions.productCategory[index], for: .normal)
            index += 1
        }
    }
}
