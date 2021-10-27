import UIKit

class TestKakaoMapViewController: UIViewController {

    @IBOutlet var mapView: MTMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mapView = MTMapView()
//        mapView.delegate = self
        mapView.baseMapType = .standard
        
        mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 35.888949648310486,
                                                                longitude: 128.6104881544238)),
                             zoomLevel: 1,
                             animated: true)
        
        mapView.layer.cornerRadius = 30
        
    }
    
    
    
    
}
