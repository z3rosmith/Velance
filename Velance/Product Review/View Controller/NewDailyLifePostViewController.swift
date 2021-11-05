import UIKit

class NewDailyLifePostViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var regionCategoryView: UIView!
    @IBOutlet var regionCategoryButtons: [VLGradientButton]!
    
    @IBOutlet weak var postImageCollectionView: UICollectionView!
    @IBOutlet weak var postTextView: UITextView!
    
    var regionOptionId: Int = 1
    var userSelectedImages = [UIImage]() {
        didSet { convertUIImagesToDataFormat() }
    }
    var userSelectedImagesInDataFormat: [Data]?
    
    static var storyboardName: String {
        StoryboardName.productReview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

//MARK: - IBActions & Target Methods

extension NewDailyLifePostViewController {
    
    
    @IBAction func pressedRegionCategoryButton(_ sender: UIButton) {
        regionCategoryButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        regionOptionId = sender.tag
        
    }
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
        
        guard let content = postTextView.text, content.count > 5 else {
            showSimpleBottomAlert(with: "글을 5자 이상 작성해주세요.")
            return
        }
        
        guard let _ = userSelectedImagesInDataFormat else {
            showSimpleBottomAlert(with: "사진을 1개 이상 골라주세요.")
            return
        }
        presentAlertWithConfirmAction(
            title: "피드 업로드를 하시겠습니까?",
            message: ""
        ) { selectedOk in
            if selectedOk { self.uploadNewDailyLife() }
        }
    }
    
    func uploadNewDailyLife() {
        
        #warning("백엔드 수정되면 위치 정보 넣어서 DTO 생성 및 보내기")
        
        let model = NewDailyLifeDTO(
            title: "",
            contents: postTextView.text!,
            files: userSelectedImagesInDataFormat!
        )
        
        CommunityManager.shared.uploadDailyLifePost(with: model) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.showSimpleBottomAlert(with: "피드 업로드 성공🎉")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            case .failure(let error):
                self.showSimpleBottomAlert(with: error.errorDescription)
            }
        }
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension NewDailyLifePostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

extension NewDailyLifePostViewController: AddImageDelegate {
    func didPickImagesToUpload(images: [UIImage]) {
        self.userSelectedImages = images
        postImageCollectionView.reloadData()
    }
}

//MARK: - UserPickedImageCellDelegate

extension NewDailyLifePostViewController: UserPickedImageCellDelegate {
    
    func didPressDeleteImageButton(at index: Int) {
        self.userSelectedImages.remove(at: index - 1)
        postImageCollectionView.reloadData()
        viewWillLayoutSubviews()
    }
}

//MARK: - Conversion Methods

extension NewDailyLifePostViewController {
    
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


extension NewDailyLifePostViewController: UITextViewDelegate {
    
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
    }
}

//MARK: - UI Configuration & Initialization

extension NewDailyLifePostViewController {
    
    private func configure() {
        title = "새 글 등록"
        configureCategoryView()
        configureRegionCategoryButtons()
        configurePostImagesCollectionView()
        configurePostTextView()
    }
    
    private func configureCategoryView() {
        regionCategoryView.layer.cornerRadius = 15
        regionCategoryView.layer.borderWidth = 0.3
        regionCategoryView.layer.borderColor = UIColor.lightGray.cgColor
        regionCategoryView.backgroundColor = UIColor(named: Colors.appBackgroundColor)
    }
    

    private func configureRegionCategoryButtons() {
        var index: Int = 1
        regionCategoryButtons.forEach { button in
            button.tag = index
            button.setTitle(UserOptions.regionOptions[index - 1], for: .normal)
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
