import UIKit

protocol RecipeTableViewCellDelegate: AnyObject {
    func didTapRecipeTableViewCell(with title: String)
}

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var recipeCollectionView: UICollectionView!
    @IBOutlet weak var seeMoreButton: UIButton!
    
    weak var delegate: RecipeTableViewCellDelegate?
    
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

//MARK: - Methods

extension RecipeTableViewCell {

    @IBAction func pressedSeeMoreButton(_ sender: UIButton) {
        
    }
}

extension RecipeTableViewCell: RecipeCollectionViewCellDelegate {
    
    func didTapRecipeCVC(with title: String, cell: RecipeCollectionViewCell) {
        let indexPath = recipeCollectionView.indexPath(for: cell)
        
        guard let index = indexPath?.item else { return }
        print("✏️ index: \(index)")
        
        
        delegate?.didTapRecipeTableViewCell(with: title)
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension RecipeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellID.recipeCollectionViewCell,
            for: indexPath
        ) as? RecipeCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.delegate = self
        cell.itemTitleLabel.text = "소세지 볶음 [\(indexPath.row)]"
        cell.itemEstimatedCookTimeLabel.text = "\(indexPath.row)분"
        cell.itemImageView.image = UIImage(named: "image_test")
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 230)
    }
}

//MARK: - UI Configuration

extension RecipeTableViewCell {
    
    private func configureCollectionView() {
        recipeCollectionView.delegate = self
        recipeCollectionView.dataSource = self
        
        let nibName = UINib(
            nibName: XIB_ID.recipeCollectionViewCell,
            bundle: nil
        )
        recipeCollectionView.register(
            nibName,
            forCellWithReuseIdentifier: CellID.recipeCollectionViewCell
        )
    }
}
