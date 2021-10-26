//
//  MallTableViewCell.swift
//  Velance
//
//  Created by Jinyoung Kim on 2021/10/26.
//

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
        
        cellView.layer.cornerRadius = 15
        cellView.layer.masksToBounds = true
        semiVeganLabel.layer.cornerRadius = 5
        semiVeganLabel.layer.masksToBounds = true
        veganLabel.layer.cornerRadius = 5
        veganLabel.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
