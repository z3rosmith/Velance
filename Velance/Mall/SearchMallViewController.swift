import UIKit

class SearchMallViewController: UIViewController {

    @IBOutlet var rangeStackView: UIStackView!
    @IBOutlet var mapView: MTMapView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    
    private var currentRadius: Double = 500
    private var currentLocation: MTMapPointGeo = MTMapPointGeo(latitude: 35.8920020620379, longitude: 128.60880797103496)
    private lazy var currentRadiusButton: UIButton = rangeStackView.subviews.first as! UIButton
    private var didCallOnce: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "내 주변 비건 식당 찾기"
        setupButtons()
        configureUI()
        configureMapView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let nextVC = segue.destination as? MallListViewController else { fatalError() }
        nextVC.mallPoint = MallPoint(x: currentLocation.longitude, y: currentLocation.latitude, radius: currentRadius)
        
        if let address = addressLabel.text {
            let addressSplit = address.split(separator: " ")
            navigationItem.backButtonTitle = "\(addressSplit[0]) \(addressSplit[1])"
        }
    }
    
    @IBAction func pressedCurrentLocationButton(_ sender: UIButton) {
        didCallOnce = false
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
    }
}

extension SearchMallViewController {
    
    private func setupButtons() {
        currentRadiusButton.isSelected = true
        rangeStackView.subviews.forEach {
            let button = $0 as! UIButton
            button.addTarget(self, action: #selector(didTapRadiusButton(_:)), for: .touchUpInside)
        }
    }
    
    private func configureUI() {
        bottomView.layer.cornerRadius = 10
        confirmButton.layer.cornerRadius = 10
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.baseMapType = .standard
        
        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        
        // 맵 중앙 미리 지정
        mapView.setMapCenter(
            MTMapPoint(geoCoord: currentLocation),
            zoomLevel: 1,
            animated: true
        )
    }
    
    @objc private func didTapRadiusButton(_ sender: UIButton) {
        currentRadiusButton.isSelected = false
        sender.isSelected = true
        currentRadiusButton = sender
        switch sender.tag {
        case 1:
            currentRadius = 1000
        case 2:
            currentRadius = 3000
        case 3:
            currentRadius = 5000
        default:
            currentRadius = 500
        }
    }
}

extension SearchMallViewController: MTMapViewDelegate {
    
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let currentLocation = location.mapPointGeo()
        if !didCallOnce {
            didCallOnce = true
            mapView.setMapCenter(
                MTMapPoint(geoCoord: currentLocation),
                zoomLevel: 1,
                animated: true
            )
            mapView.currentLocationTrackingMode = .off
        }
    }
    
    func mapView(_ mapView: MTMapView!, centerPointMovedTo mapCenterPoint: MTMapPoint!) {
        let currentLocation = mapCenterPoint.mapPointGeo()
        print("✏️ new latitude: \(currentLocation.latitude) and new longitude: \(currentLocation.longitude)")
    }
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        let address = MTMapReverseGeoCoder.findAddress(for: mapCenterPoint, withOpenAPIKey: KakaoAPIKey.API_Key)
        
        guard let address = address else { return }
        
        currentLocation = mapCenterPoint.mapPointGeo()
        DispatchQueue.main.async {
            self.addressLabel.text = address
        }
    }
}
