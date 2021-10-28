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
    
    var mallId: Int?
    var placeName: String?
    var phone: String?
    var addressName: String?
    var roadAddressName: String?
    var x: Double?
    var y: Double?
    // -------
    var mallImageData: Data?
    var onlyVegan: String = "N"
    var didSelectMallCategory: Bool = false
    
    
    static var storyboardName: String {
        StoryboardName.mall
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // 이전 화면의 검색결과에서 받아온 placeName
        if let placeName = placeName {
            mallNameTextField.text = placeName
        }
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
        didSelectMallCategory = true
    }
    
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
        
        // 여기서 통신
        guard let mallImageData = mallImageData else {
            showSimpleBottomAlert(with: "식당 썸네일로 사용할 사진 1개를 골라주세요.")
            return
        }
        
        if !didSelectMallCategory {
            showSimpleBottomAlert(with: "식당 종류를 하나 선택해주세요.")
            return
        }
        
        presentAlertWithConfirmAction(
            title: "식당을 새로 등록하시겠습니까?",
            message: ""
        ) { [weak self] selectedOk in
            guard let self = self else { return }
            if selectedOk {
                
                guard
                    let mallId = self.mallId,
                    let placeName = self.placeName,
                    let phone = self.phone,
                    let addressName = self.addressName,
                    let roadAddressName = self.roadAddressName,
                    let x = self.x,
                    let y = self.y else {
                        self.showSimpleBottomAlert(with: "신규 식당 등록에 문제가 생겼습니다. 잠시 후 다시 시도해주세요.")
                        return
                    }
                
                let model = NewMallDTO(mallId: mallId, placeName: placeName, phone: phone, addressName: addressName, roadAddressName: roadAddressName, x: x, y: y, onlyVegan: self.onlyVegan, file: self.mallImageData!)
                
                MallManager.shared.uploadNewMall(with: model) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        self.showSimpleBottomAlert(with: "식당 등록 성공🎉")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let error):
                        self.showSimpleBottomAlert(with: error.errorDescription)
                    }
                }
            }
        }
        
        
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
        mallNameTextField.placeholder = nil
        mallNameTextField.isUserInteractionEnabled = false
        mallNameTextField.font = .systemFont(ofSize: 18, weight: .medium)
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
