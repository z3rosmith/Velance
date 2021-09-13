import UIKit

class ShoppingTableViewCell: UITableViewCell {

    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func configure() {
        configureCollectionView()
        
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
        else { fatalError() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 230)
    }
    

}
