import UIKit

class NewProductReviewViewController: UIViewController, Storyboarded {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var starRating: RatingStackView!
    @IBOutlet weak var reviewImageCollectionView: UICollectionView!
    @IBOutlet weak var reviewTextView: UITextView!
    
    //MARK: - Properties
    var userSelectedImages = [UIImage]() {
        didSet { convertUIImagesToDataFormat() }
    }
    
    //MARK: - NewReviewDTO Properties
    var productId: Int?
    var contents: String?
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

extension NewProductReviewViewController {
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
        
        guard let imageDatas = userSelectedImagesInDataFormat else {
            showSimpleBottomAlert(with: "제품 사진을 하나 이상 골라주세요!")
            return
        }
        
        guard let contents = contents else {
            showSimpleBottomAlert(with: "제품에 대한 리뷰를 조금이라도 작성해주세요!")
            return
        }
        
        presentAlertWithConfirmAction(title: "리뷰를 등록하시겠습니까?", message: "") { [weak self] selectedOk in
            guard let self = self else { return }
            if selectedOk {
                let model = NewReviewDTO(
                    productId: self.productId ?? 0,
                    rating: self.starRating.starsRating,
                    contents: contents,
                    files: imageDatas
                )
                showProgressBar()
                ProductManager.shared.uploadNewReview(with: model) { [weak self] result in
                    guard let self = self else { return }
                    dismissProgressBar()
                    switch result {
                    case .success:
                        self.showSimpleBottomAlert(with: "리뷰 등록에 성공하셨어요.🎉")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
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


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension NewProductReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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

extension NewProductReviewViewController: AddImageDelegate {
    
    func didPickImagesToUpload(images: [UIImage]) {
        self.userSelectedImages = images
        reviewImageCollectionView.reloadData()
    }
}


//MARK: - UserPickedImageCellDelegate

extension NewProductReviewViewController: UserPickedImageCellDelegate {

    func didPressDeleteImageButton(at index: Int) {

        self.userSelectedImages.remove(at: index - 1)
        reviewImageCollectionView.reloadData()
        viewWillLayoutSubviews()
    }
}

//MARK: - Conversion Methods

extension NewProductReviewViewController {
    
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

//MARK: - UITextViewDelegate -> For reviewTextView

extension NewProductReviewViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    
        if textView.text.isEmpty {
            textView.text = "제품에 대한 리뷰를 남겨주세요 :)"
            textView.textColor = UIColor.lightGray
            return
        }
        self.contents = textView.text
    }
}



//MARK: - UI Configuration & Initialization

extension NewProductReviewViewController {
    
    private func configure() {
        title = "리뷰 등록"
        starRating.setStarsRating(rating: 4)
        configureReviewCollectionView()
        configureReviewTextView()
    }
    
    private func configureReviewCollectionView() {
        reviewImageCollectionView.delegate = self
        reviewImageCollectionView.dataSource = self
        reviewImageCollectionView.alwaysBounceHorizontal = true
    }
    
    private func configureReviewTextView() {
        reviewTextView.delegate = self
        reviewTextView.layer.cornerRadius = 15
        reviewTextView.layer.borderWidth = 0.3
        reviewTextView.clipsToBounds = true
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
        reviewTextView.text = "제품에 대한 리뷰를 남겨주세요 :)"
        reviewTextView.textColor = UIColor.lightGray
    }
}
