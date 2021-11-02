import UIKit
import SnapKit

class TestKakaoMapViewController: UIViewController {

    var mapView: MTMapView?
    
    private let defaultLocation = MTMapPointGeo(latitude: 37.497866841186955, longitude: 127.02753316658152)
    
    private var didSetUserInitialLocation: Bool = false
    
    let pointMarker = MTMapPOIItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()
        
    }
    
    func configureMapView() {
        mapView = MTMapView()
        mapView?.delegate = self
        mapView?.baseMapType = .standard
        mapView?.setMapCenter(
            MTMapPoint(geoCoord: defaultLocation),
            zoomLevel: 1,
            animated: true
        )
        
        mapView?.showCurrentLocationMarker = true
        mapView?.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        
        
        pointMarker.markerType = .customImage
        pointMarker.mapPoint = MTMapPoint(geoCoord: defaultLocation)
        pointMarker.showAnimationType = .springFromGround
        pointMarker.customImageName = "mapMarker"
        pointMarker.markerSelectedType = .customImage
        pointMarker.customImageAnchorPointOffset = MTMapImageOffset(offsetX: 5, offsetY: 0)
        pointMarker.draggable = false
        
        mapView?.delegate = self

        if let mapView = mapView {
            view.addSubview(mapView)
        }

        
        mapView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        mapView?.add(pointMarker)
        
        
    }
}

extension TestKakaoMapViewController: MTMapViewDelegate {
    
    // 현재 위치 받아오기
    
    
//    func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
//        print("MTMapView updateDeviceHeading (\(headingAngle)) degrees")
//    }
//
//    func mapView(_ mapView: MTMapView!, draggablePOIItem poiItem: MTMapPOIItem!, movedToNewMapPoint newMapPoint: MTMapPoint!) {
//
//        let currentLocation = newMapPoint?.mapPointGeo()
//        if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude {
//            print("✏️ new latitude: \(latitude) and new longitude: \(longitude)")
//        }
//
//
//    }
    
    func mapView(_ mapView: MTMapView!, centerPointMovedTo mapCenterPoint: MTMapPoint!) {
        let currentLocation = mapCenterPoint.mapPointGeo()
        print("✏️ new latitude: \(currentLocation.latitude) and new longitude: \(currentLocation.longitude)")
        pointMarker.mapPoint = MTMapPoint(geoCoord: currentLocation)
    }
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        
    }
}
