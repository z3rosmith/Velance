import UIKit
import SnapKit
import SwiftUI

class MallHeaderView: UIView {
    
    //MARK: - Constants
    fileprivate struct Metrics {
        static let labelPadding: CGFloat = 24
    }
    
    //MARK: - UI
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    let veganOnlyMallLabel: UILabel = {
        let label = UILabel()
        label.text = "비건 식당"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = UIColor(named: "4D8800") ?? .systemGreen
        label.widthAnchor.constraint(equalToConstant: 65).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    let nonVeganMallLabel: UILabel = {
        let label = UILabel()
        label.text = "비건 메뉴 포함"
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = UIColor(named: "CDCF67") ?? .systemYellow
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        label.heightAnchor.constraint(equalToConstant: 22).isActive = true
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    let goToMapButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.circle"), for: .normal)
        button.setTitle("지도로 보기", for: .normal)
        button.setTitleColor(UIColor(named: "4D8800") ?? .systemGreen, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.tintColor = UIColor(named: "4D8800") ?? .systemGreen
        return button
    }()
    
    let registeredMenuLabel: UILabel = {
        let label = UILabel()
        label.text = "등록된 메뉴"
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.widthAnchor.constraint(equalToConstant: 34).isActive = true
        view.heightAnchor.constraint(equalToConstant: 3).isActive = true
        return view
    }()
    
    
    
    //MARK: - Configuration
    
    func configure(mallName: String?, isVegan: String?, mallAddress: String?) {
        
        titleLabel.text = mallName ?? "식당 정보 표시 오류"
        addressLabel.text = mallAddress ?? "-"
        
        addSubview(titleLabel)
        
        
//        isVegan == "Y" ? addSubview(veganOnlyMallLabel) : addSubview(nonVeganMallLabel)
      
        addSubview(veganOnlyMallLabel)
        addSubview(nonVeganMallLabel)
        
        
        if isVegan == "Y" {
            nonVeganMallLabel.isHidden = true
        } else {
            veganOnlyMallLabel.isHidden = true
        }
        
        addSubview(addressLabel)
        addSubview(goToMapButton)
        addSubview(registeredMenuLabel)
        
//        addSubview(separatorView)
        makeConstraints()
    }
    
    func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.left.equalTo(self.snp.left).offset(Metrics.labelPadding)
            make.right.equalTo(self.snp.right).offset(-Metrics.labelPadding)
        }
        
        veganOnlyMallLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(self.snp.left).offset(Metrics.labelPadding)
        }
        
        nonVeganMallLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(self.snp.left).offset(Metrics.labelPadding)
        }
    
        goToMapButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14.5)
            make.right.equalTo(self.snp.right).offset(-6)
        }

        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14.5)
            make.left.equalTo(nonVeganMallLabel.snp.right).offset(8)
            make.right.equalTo(goToMapButton.snp.left).offset(6)
        }

        registeredMenuLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.left.equalTo(self.snp.left).offset(Metrics.labelPadding)
            make.right.equalTo(self.snp.right).offset(-Metrics.labelPadding)
        }
        

    }
}
