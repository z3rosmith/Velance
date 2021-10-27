import UIKit

class TestKakaoMapViewController: UIViewController {

    @IBOutlet var mapView: MTMapView!
    
    private let defaultLocation = MTMapPointGeo(latitude: 37.497866841186955, longitude: 127.02753316658152)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapView()

    }
    
    func configureMapView() {
        
        mapView = MTMapView()
        mapView.delegate = self
        mapView.baseMapType = .standard
        
        mapView.setMapCenter(MTMapPoint(geoCoord: defaultLocation),
                             zoomLevel: 1,
                             animated: true)
        
        
        
        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithoutHeading
        
        
        let mapPoint = MTMapPoint(geoCoord: defaultLocation)
        
        let pointItem = MTMapPOIItem()
        pointItem.showAnimationType = .dropFromHeaven
        pointItem.markerType = .redPin
        pointItem.mapPoint = mapPoint
        pointItem.draggable = true
        
        mapView.add(pointItem)
        
        
        
        
        
    }
    
}

extension TestKakaoMapViewController: MTMapViewDelegate {
    
    
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude{
            print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")
            
            
          
            
        }
    }
    
    func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
        print("MTMapView updateDeviceHeading (\(headingAngle)) degrees")
    }
}
