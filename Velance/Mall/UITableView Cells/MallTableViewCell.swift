import UIKit

class MallTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var mallImageView: UIImageView!
    @IBOutlet weak var mallnameLabel: UILabel!
    @IBOutlet weak var menuCountLabel: UILabel!
    @IBOutlet weak var mallAddressLabel: UILabel!
    @IBOutlet weak var semiVeganLabel: UILabel!
    @IBOutlet weak var veganLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        cellView.clipsToBounds = true
        cellView.layer.masksToBounds = false
        cellView.layer.shadowRadius = 3
        cellView.layer.shadowOpacity = 0.3
        cellView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellView.layer.shadowColor = UIColor.darkGray.cgColor
        cellView.layer.cornerRadius = 10
        
        semiVeganLabel.layer.cornerRadius = 5
        semiVeganLabel.layer.masksToBounds = true
        veganLabel.layer.cornerRadius = 5
        veganLabel.layer.masksToBounds = true
        
        mallImageView.layer.cornerRadius = 10
        mallImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
}
