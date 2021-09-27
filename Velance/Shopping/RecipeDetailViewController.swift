import UIKit
import youtube_ios_player_helper

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var estimatedCookTimeLabel: UILabel!
    @IBOutlet weak var foodCategoryLabel: UILabel!
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

//MARK: -  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension RecipeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CellID.shoppingItemCollectionViewCell,
            for: indexPath
        ) as? ShoppingItemCollectionViewCell
        else { return UICollectionViewCell() }
        
        
        cell.itemTitleLabel.text = "[\(indexPath.row)] 요리 재료"
        cell.itemDetailLabel.text = "\(indexPath.row)팩, 200g"
        cell.itemPriceLabel.text = "10,000원 [\(indexPath.row)]"
        cell.itemImageView.image = UIImage(named: "image_test")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 165, height: 230)
    }
    
    
}

//MARK: - UI Configuration

extension RecipeDetailViewController {
    
    private func configure() {
        
        configureYouTubePlayer()
        configureCollectionView()
    }
    
    private func configureYouTubePlayer() {
        playerView.load(withVideoId: "NFXpPRKfpmA")
    }
    
    private func configureCollectionView() {
        ingredientsCollectionView.delegate = self
        ingredientsCollectionView.dataSource = self
        
        let nibName = UINib(
            nibName: XIB_ID.shoppingItemCollectionViewCell,
            bundle: nil
        )
        ingredientsCollectionView.register(
            nibName,
            forCellWithReuseIdentifier: CellID.shoppingItemCollectionViewCell
        )
        
    }
    
}
