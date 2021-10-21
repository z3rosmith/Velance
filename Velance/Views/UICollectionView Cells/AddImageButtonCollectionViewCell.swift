import UIKit
import BSImagePicker
import Photos

protocol AddImageDelegate {
    func didPickImagesToUpload(images: [UIImage])
}

class AddImageButtonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addImageButton: UIButton!
    
    var delegate: AddImageDelegate!
    
    var selectedAssets: [PHAsset] = [PHAsset]()
    var userSelectedImages: [UIImage] = [UIImage]()
    
    var maxSelection: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("✏️ AddImageButton init")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("✏️ AddImageButton required init")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        addImageButton.layer.borderWidth = 1
        addImageButton.layer.borderColor = UIColor.lightGray.cgColor
        addImageButton.layer.cornerRadius = 5
    }
    
    @IBAction func pressedAddButton(_ sender: UIButton) {
                
        /// 기존 선택된 사진 모두 초기화
        selectedAssets.removeAll()
        userSelectedImages.removeAll()
        
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = maxSelection
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        
        let vc = self.window?.rootViewController
        
        vc?.presentImagePicker(imagePicker, select: { (asset) in
        }, deselect: { (asset) in
        }, cancel: { (assets) in
        }, finish: { (assets) in
            for i in 0..<assets.count {
                self.selectedAssets.append(assets[i])
            }
            self.convertAssetToImages()
            self.delegate?.didPickImagesToUpload(images: self.userSelectedImages)
        })
     }
    
    func convertAssetToImages() {
        
        if selectedAssets.count != 0 {
            
            for i in 0..<selectedAssets.count {
                
                let imageManager = PHImageManager.default()
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                option.deliveryMode = .highQualityFormat
                option.resizeMode = .exact
    
                var thumbnail = UIImage()
                
                imageManager.requestImage(
                    for: selectedAssets[i],
                       targetSize: CGSize(width: 1000, height: 1000),
                       contentMode: .aspectFill,
                       options: option
                ) { (result, info) in
                    thumbnail = result!
                }
        
                let data = thumbnail.jpegData(compressionQuality: 1.0)
                let newImage = UIImage(data: data!)
            
                self.userSelectedImages.append(newImage! as UIImage)
            }
        }
    }
}
