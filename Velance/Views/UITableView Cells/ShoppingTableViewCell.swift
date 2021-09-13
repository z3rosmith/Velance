import UIKit

class ShoppingTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    @IBOutlet weak var seeMoreButton: UIButton!
    
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
    
    
    @IBAction func pressedSeeMoreButton(_ sender: UIButton) {
        
    }
    

    private func configureCollectionView() {
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
  
        let nibName = UINib(nibName: XIB_ID.shoppingItemCollectionViewCell, bundle: nil)
        itemCollectionView.register(nibName, forCellWithReuseIdentifier: CellID.shoppingItemCollectionViewCell)
    }

}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ShoppingTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CellID.shoppingItemCollectionViewCell,
                for: indexPath
        ) as? ShoppingItemCollectionViewCell
        else { return UICollectionViewCell() }
        
        
        cell.itemTitleLabel.text = "[\(indexPath.row)] 비건 소세지"
        cell.itemDetailLabel.text = "\(indexPath.row)팩, 200g"
        cell.itemPriceLabel.text = "10,000원 [\(indexPath.row)]"
        cell.itemImageView.image = UIImage(named: "image_test")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 230)
    }
    

}
