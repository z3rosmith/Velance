import UIKit
import TextFieldEffects

class NewMallViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var mallThumbnailImageView: UIImageView!
    @IBOutlet weak var mallNameTextField: HoshiTextField!
    
    @IBOutlet weak var chooseCategoryView: UIView!
    @IBOutlet var categoryButtons: [VLGradientButton]!
    
    @IBOutlet weak var doneButton: UIButton!
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .savedPhotosAlbum
        return imagePicker
    }()
    
    
    //MARK: - NewMallDTO Properties
    #warning("수정 필요 -> 지도에서 값을 가져와야함")
    
    var mallImageData: Data?
    var onlyVegan: String = "N"
    
    
    static var storyboardName: String {
        StoryboardName.mall
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

    }
}

//MARK: - IBActions & Target Methods

extension NewMallViewController {
    
    @IBAction func pressedAddImageButton(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func pressedCategoryButton(_ sender: UIButton) {
        categoryButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        onlyVegan = sender.tag == 0 ? "Y" : "N"
    }
    
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
        
        // 여기서 통신
    }
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension NewMallViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage: UIImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            dismiss(animated: true) {
                DispatchQueue.main.async {
                    self.mallThumbnailImageView.image = originalImage
                    self.mallImageData = originalImage.jpegData(compressionQuality: 1.0)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


//MARK: - Initialization & UI Configuration

extension NewMallViewController {
    
    private func configure() {
        title = "새 식당 등록"
        configureAddImageButton()
        configureMallThumbnailImageView()
        configureTextFields()
        configureUIViews()
        configureCategoryButtons()
        
    }
    
    private func configureAddImageButton() {
        addImageButton.layer.borderWidth = 1
        addImageButton.layer.borderColor = UIColor.lightGray.cgColor
        addImageButton.layer.cornerRadius = 5
    }
    
    private func configureMallThumbnailImageView() {
        mallThumbnailImageView.layer.cornerRadius = 5
        mallThumbnailImageView.contentMode = .scaleAspectFill
    }
    
    private func configureTextFields() {
        //isUserInteractionEnabled = false 설정 추후에 적용
        
    }
    
    private func configureUIViews() {
        chooseCategoryView.layer.cornerRadius = 15
        chooseCategoryView.layer.borderWidth = 0.3
        chooseCategoryView.layer.borderColor = UIColor.lightGray.cgColor
        chooseCategoryView.backgroundColor = UIColor(named: Colors.appBackgroundColor)
    }
    
    private func configureCategoryButtons() {

    }
}
