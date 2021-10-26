import UIKit

class NewPostViewController: UIViewController, Storyboarded {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var feedCategoryView: UIView!
    @IBOutlet var feedCategoryButtons: [VLGradientButton]!
    
    @IBOutlet weak var recipeCategoryView: UIView!
    @IBOutlet var recipeCategoryButtons: [VLGradientButton]!
    
    @IBOutlet weak var postImageCollectionView: UICollectionView!
    @IBOutlet weak var postTextView: UITextView!
    
    //MARK: - Properties
    var userSelectedImages = [UIImage]() {
        didSet { convertUIImagesToDataFormat() }
    }
    
    var userSelectedImagesInDataFormat: [Data]?
    
    var contents: String?
    
    
    
    static var storyboardName: String {
        StoryboardName.productReview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }


}

//MARK: - IBActions & Target Methods

extension NewPostViewController {
    
    @IBAction func pressedFeedCategoryButton(_ sender: UIButton) {
        feedCategoryButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        
        if sender.tag == 1 {
            recipeCategoryButtons.forEach {
                $0.isSelected = false
                $0.isUserInteractionEnabled = false
            }
        } else {
            recipeCategoryButtons.forEach { $0.isUserInteractionEnabled = true }
        }
        
    }
    
    @IBAction func pressedRecipeCategoryButton(_ sender: UIButton) {
        recipeCategoryButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        
        
    }
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
        
        
    }
    
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension NewPostViewController: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Add Button 이 항상 있어야하므로 + 1
        return self.userSelectedImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let addImageButtonCellIdentifier = "AddImageButtonCollectionViewCell"
        let newFoodImageCellIdentifier = "UserPickedImageCollectionViewCell"
        
        /// 첫 번째 Cell 은 항상 Add Button
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addImageButtonCellIdentifier, for: indexPath) as? AddImageButtonCollectionViewCell else {
                fatalError()
            }
            cell.maxSelection = 3
            cell.delegate = self
            return cell
        }
        
        /// 그 외의 셀은 사용자가 고른 사진으로 구성된  Cell
        else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: newFoodImageCellIdentifier, for: indexPath) as? UserPickedImageCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.indexPath = indexPath.item
            
            // 사용자가 앨범에서 고른 사진이 있는 경우
            if self.userSelectedImages.count > 0 {
                cell.userPickedImageView.image = self.userSelectedImages[indexPath.item - 1]
            }
            return cell
        }
    }
}

//MARK: - AddImageDelegate

extension NewPostViewController: AddImageDelegate {
    func didPickImagesToUpload(images: [UIImage]) {
        self.userSelectedImages = images
        postImageCollectionView.reloadData()
    }
}

//MARK: - UserPickedImageCellDelegate

extension NewPostViewController: UserPickedImageCellDelegate {
    func didPressDeleteImageButton(at index: Int) {

        self.userSelectedImages.remove(at: index - 1)
        postImageCollectionView.reloadData()
        viewWillLayoutSubviews()
    }
}

//MARK: - Conversion Methods

extension NewPostViewController {
    
    func convertUIImagesToDataFormat() {
        userSelectedImagesInDataFormat?.removeAll()
        userSelectedImagesInDataFormat = userSelectedImages.map( { (image: UIImage) -> Data in
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                return Data()
            }
            return imageData
        })
    }
}

//MARK: - UITextViewDelegate


extension NewPostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    
        if textView.text.isEmpty {
            textView.text = "글을 작성해주세요 :)"
            textView.textColor = UIColor.lightGray
            return
        }
        self.contents = textView.text
    }
}

//MARK: - UI Configuration & Initialization

extension NewPostViewController {
    
    private func configure() {
        title = "새 글 등록"
        configureCategoryViews()
        configureFeedCategoryButtons()
        configureRecipeCategoryButtons()
        configurePostImagesCollectionView()
        configurePostTextView()
    }
    
    private func configureCategoryViews() {
        [feedCategoryView, recipeCategoryView].forEach { view in
            guard let view = view else { return }
            view.layer.cornerRadius = 15
            view.layer.borderWidth = 0.3
            view.layer.borderColor = UIColor.lightGray.cgColor
            view.backgroundColor = UIColor(named: Colors.appBackgroundColor)
            
        }
    }
    
    private func configureFeedCategoryButtons() {
        
        
        
    }
    
    private func configureRecipeCategoryButtons() {
        var index: Int = 1
        recipeCategoryButtons.forEach { button in
            button.tag = index
            button.setTitle(UserOptions.recipeType[index - 1], for: .normal)
            index += 1
        }
    }
    
    
    
    private func configurePostImagesCollectionView() {
        postImageCollectionView.delegate = self
        postImageCollectionView.dataSource = self
        postImageCollectionView.alwaysBounceHorizontal = true
    }
    
    private func configurePostTextView() {
        postTextView.delegate = self
        postTextView.layer.cornerRadius = 15
        postTextView.layer.borderWidth = 0.3
        postTextView.clipsToBounds = true
        postTextView.layer.borderColor = UIColor.lightGray.cgColor
        postTextView.text = "글을 작성해주세요 :)"
        postTextView.textColor = UIColor.lightGray
    }
    
    
}
