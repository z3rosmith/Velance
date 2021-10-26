import UIKit
import TextFieldEffects

class NewMenuViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var menuThumbnailImageView: UIImageView!
    
    @IBOutlet weak var menuNameTextField: HoshiTextField!
    @IBOutlet weak var menuPriceTextField: HoshiTextField!
    @IBOutlet weak var menuCautionsTextField: HoshiTextField!
    
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .savedPhotosAlbum
        return imagePicker
    }()
    
    //MARK: - NewMenuDTO Properties
    var menuImageData: Data?
    var mallId: Int?
    
    
    static var storyboardName: String {
        StoryboardName.main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    

}

//MARK: - IBActions & Target Methods

extension NewMenuViewController {
    @IBAction func pressedAddImageButton(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension NewMenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            dismiss(animated: true) {
                DispatchQueue.main.async {
                    self.menuThumbnailImageView.image = originalImage
                    self.menuImageData = originalImage.jpegData(compressionQuality: 1.0)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Initialization & UI Configuration

extension NewMenuViewController {
    
    private func configure() {
        title = "새 메뉴 등록"
        configureAddImageButton()
        configureMenuThumbnailImageView()
        configureTextFields()
    }
    
    
    private func configureAddImageButton() {
        addImageButton.layer.borderWidth = 1
        addImageButton.layer.borderColor = UIColor.lightGray.cgColor
        addImageButton.layer.cornerRadius = 5
    }
    
    private func configureMenuThumbnailImageView() {
        menuThumbnailImageView.layer.cornerRadius = 5
        menuThumbnailImageView.contentMode = .scaleAspectFill
    }
    
    private func configureTextFields() {

        
    }
}

