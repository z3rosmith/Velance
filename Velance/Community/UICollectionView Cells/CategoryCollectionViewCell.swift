import UIKit
import SnapKit

class CategoryCollectionViewCell: UICollectionViewCell {
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(categoryLabel)
        
        categoryLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
