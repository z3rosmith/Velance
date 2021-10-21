import UIKit

protocol UserPickedImageCellDelegate {
    func didPressDeleteImageButton(at index: Int)
}

// 리뷰 또는 신규 식당 등록 시 사용자가 고른 이미지가 표시되는 Collection View Cell

class UserPickedImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userPickedImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: UserPickedImageCellDelegate!
    
    var indexPath: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userPickedImageView.contentMode = .scaleAspectFill
        userPickedImageView.layer.cornerRadius = 5
    }
    
    @IBAction func pressedCancelButton(_ sender: UIButton) {
        delegate?.didPressDeleteImageButton(at: indexPath)
    }

}
