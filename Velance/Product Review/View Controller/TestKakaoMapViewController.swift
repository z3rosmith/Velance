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
        mapView?.setMapCenter(
            MTMapPoint(geoCoord: defaultLocation),
            zoomLevel: 1,
            animated: true
        )
        
        mapView?.baseMapType = .standard
        mapView?.showCurrentLocationMarker = true
        mapView?.currentLocationTrackingMode = .onWithoutHeading
        
        
        pointMarker.markerType = .customImage
        pointMarker.mapPoint = MTMapPoint(geoCoord: defaultLocation)
        pointMarker.showAnimationType = .springFromGround
        pointMarker.customImageName = "mapMarker"
        pointMarker.markerSelectedType = .customImage
        pointMarker.customImageAnchorPointOffset = MTMapImageOffset(offsetX: 5, offsetY: 0)
        pointMarker.draggable = true
        
        mapView?.delegate = self

        if let mapView = mapView {
            view.addSubview(mapView)
        }

        
        mapView?.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        mapView?.add(pointMarker)
        
        
    }
    
    func setMarkerLocationToUserCurrentLocation(mapPointGeo: MTMapPointGeo) {
        
        print("✏️ setting new location.....")
        didSetUserInitialLocation = true
        
        pointMarker.mapPoint = MTMapPoint(geoCoord: mapPointGeo)
        
    }
    
}

extension TestKakaoMapViewController: MTMapViewDelegate {
    
    // 현재 위치 받아오기
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        print("✏️ withAccuracy")
        let currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude{
            print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")

//            if !didSetUserInitialLocation {
                let newLocation = MTMapPointGeo(latitude: latitude, longitude: longitude)
                self.setMarkerLocationToUserCurrentLocation(mapPointGeo: newLocation)
//            }

        }
    }


    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, with accuracy: MTMapLocationAccuracy) {
        print("✏️ with accuracy")
        let currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude{
            print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")

//            if !didSetUserInitialLocation {
                let newLocation = MTMapPointGeo(latitude: latitude, longitude: longitude)
                self.setMarkerLocationToUserCurrentLocation(mapPointGeo: newLocation)
//            }

        }
    }


    
    
    func mapView(_ mapView: MTMapView!, draggablePOIItem poiItem: MTMapPOIItem!, movedToNewMapPoint newMapPoint: MTMapPoint!) {
    
        let currentLocation = newMapPoint?.mapPointGeo()
        if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude {
            print("✏️ new latitude: \(latitude) and new longitude: \(longitude)")
        }
        
        
    }
}
