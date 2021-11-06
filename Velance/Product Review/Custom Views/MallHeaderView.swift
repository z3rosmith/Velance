import UIKit
import SnapKit
import SwiftUI

class MallHeaderView: UIView {
    
    //MARK: - Properties
    var mallId: Int?
    
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
        button.addTarget(self, action: #selector(openKakaoMapApp), for: .touchUpInside)
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
    

    //MARK: - Configuration
    
    func configure(mallId: Int?, mallName: String?, isVegan: String?, mallAddress: String?) {
        
        self.mallId = mallId
        titleLabel.text = mallName ?? "식당 정보 표시 오류"
        addressLabel.text = mallAddress ?? "-"
        
        addSubview(titleLabel)
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

//MARK: - Target Methods

extension MallHeaderView {
    
    @objc private func openKakaoMapApp() {
        guard let mallId = mallId else { return }
        let urlString = "kakaomap://place?id=\(mallId)"
        guard let url = URL(string: urlString) else { return }
        
        print("✏️ urlString: \(urlString)")
        
        if UIApplication.shared.canOpenURL(url) {
            
            self.window?.rootViewController?.presentAlertWithConfirmAction(
                title: "카카오맵 열기",
                message: "카카오맵으로 연결하시겠습니까?"
            ) { selectedOk in
                if selectedOk {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
        } else {
            
            guard let appStoreUrl = URL(string: "https://itunes.apple.com/us/app/id304608425?mt=8") else { return }
        
            self.window?.rootViewController?.presentAlertWithConfirmAction(
                title: "카카오맵 설치",
                message: "카카오맵 설치 화면으로 이동하시겠습니까?"
            ) { selectedOk in
                if selectedOk {
                    UIApplication.shared.open(appStoreUrl, options: [:], completionHandler: nil)
                }
            }
            
        }
    }
}
