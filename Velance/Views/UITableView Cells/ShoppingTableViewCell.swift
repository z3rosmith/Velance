import UIKit

class ShoppingTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    
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
        
        cell.itemTitleLabel.text = String(indexPath.row)
        cell.itemDetailLabel.text = String(indexPath.row)
        cell.itemPriceLabel.text = String(indexPath.row)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 230)
    }
    

}
