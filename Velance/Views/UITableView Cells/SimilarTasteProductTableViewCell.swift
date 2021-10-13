import UIKit

class SimilarTasteProductTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var similarTasteCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SimilarTasteProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = similarTasteCollectionView.dequeueReusableCell(
            withReuseIdentifier: CellID.productForSimilarTasteCVC,
            for: indexPath
        ) as? ProductForSimilarTasteCVC
        else { return UICollectionViewCell() }
        
        cell.productTitleLabel.text = "[\(indexPath.row)] 비건 소세지"
        cell.productVeganTypeLabel.text = "[\(indexPath.row)] 페스코,비건"
        cell.productPriceLabel.text = "[\(indexPath.row)] 10,000원"
        cell.productRatingLabel.text = "\(indexPath.row).3"
        cell.productImageView.image = UIImage(named: "image_test")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 280, height: 140)
    }
    
    
}

//MARK: - UI Configuration

extension SimilarTasteProductTableViewCell {
    
    private func configureCollectionView() {
        similarTasteCollectionView.delegate = self
        similarTasteCollectionView.dataSource = self
        
        let nibNameSimilarTaste = UINib(
            nibName: XIB_ID.productForSimilarTasteCVC,
            bundle: nil
        )
        similarTasteCollectionView.register(
            nibNameSimilarTaste,
            forCellWithReuseIdentifier: CellID.productForSimilarTasteCVC
        )
    }
}
