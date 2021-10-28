import UIKit
import PanModal

class SearchNewMallViewController: UIViewController {
    
    @IBOutlet var mapView: MTMapView!
    @IBOutlet var searchBar: UISearchBar!
    
    var mapPoint: MTMapPoint?
    var pointItem: MTMapPOIItem?
    
    private let viewModel = SearchMallViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
}

//MARK: - Target Methods

extension SearchNewMallViewController {
    
    func presentVerificationAlert() {

        guard let placeSelected = viewModel.currentlySelectedIndex else { return }
        
        let placeName = viewModel.placeName[placeSelected]
        
        let alert = UIAlertController(
            title: "위치가 여기 맞나요?",
            message: placeName,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "다시 고를래요",
            style: .default,
            handler: nil)
        )
        alert.addAction(UIAlertAction(
            title: "네 맞아요!",
            style: .default
        ) { [weak self] action in
            guard let self = self else { return }
            
            guard let newMallVC = NewMallViewController.instantiate() as? NewMallViewController else { return }
            
            let mallInfo = self.viewModel.documents[placeSelected]
            
            newMallVC.mallId = Int(mallInfo.id)
            newMallVC.placeName = mallInfo.placeName
            newMallVC.phone = mallInfo.contact
            newMallVC.addressName = mallInfo.address
            newMallVC.roadAddressName = mallInfo.roadAddressName
            newMallVC.x = Double(mallInfo.x)
            newMallVC.y = Double(mallInfo.y)
            
            self.navigationController?.pushViewController(newMallVC, animated: true)
            
        })
        
        self.present(alert, animated: true)
    }
}


//MARK: - MTMapViewDelegate

extension SearchNewMallViewController: MTMapViewDelegate {
    
    func updateMapWithMarker(longitude: Double, latitude: Double, placeName: String) {
        
        mapView.setMapCenter(
            MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude)),
            zoomLevel: 1,
            animated: true
        )
        mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
        
        pointItem = MTMapPOIItem()
        pointItem?.showAnimationType = .springFromGround
        pointItem?.markerType = .bluePin
        pointItem?.mapPoint = mapPoint
        pointItem?.itemName = placeName
        pointItem?.showDisclosureButtonOnCalloutBalloon = true

        mapView.add(pointItem)
        mapView.select(pointItem, animated: true)
    
    }
    
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        presentVerificationAlert()
    }
    
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonRightSideOf poiItem: MTMapPOIItem!) {
        presentVerificationAlert()
    }
}


//MARK: - SearchRestaurantViewModelDelegate

extension SearchNewMallViewController: SearchMallViewModelDelegate {

    func didFetchSearchResults() {
        
        guard let searchModalVC = storyboard?.instantiateViewController(
            identifier: "SearchListViewController"
        ) as? SearchListViewController else { return }

        searchModalVC.placeName = viewModel.placeName
        searchModalVC.address = viewModel.address
        searchModalVC.searchResultCount = viewModel.placeName.count
        searchModalVC.delegate = self
        self.presentPanModal(searchModalVC)
//        presentPanModal(searchModalVC)
    }
    
    func failedFetchingSearchResults(with error: NetworkError) {
        print("❗️ failedFetchingSearchResults")
        showSimpleBottomAlert(with: error.errorDescription)
    }
}

//MARK: - SearchListDelegate

extension SearchNewMallViewController: SearchListDelegate {
    
    func didChoosePlace(index: Int) {
        mapView.removeAllPOIItems()
        let (longitude, latitude, placeName) = viewModel.fetchLocation(of: index)
        updateMapWithMarker(longitude: longitude, latitude: latitude, placeName: placeName)
    }
}


//MARK: - UITableViewDelegate & UITableViewDataSource

extension SearchNewMallViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.placeName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "searchedRestaurantResultCell"
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellIdentifier
        ) else { return UITableViewCell() }

        /// 검색된 결과가 있을 경우
        if viewModel.totalCount != 0 {
            cell.textLabel?.text = viewModel.placeName[indexPath.row]
            cell.detailTextLabel?.text = viewModel.address[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapView.removeAllPOIItems()
        let (longitude, latitude, placeName) = viewModel.fetchLocation(of: indexPath.row)
        updateMapWithMarker(longitude: longitude, latitude: latitude, placeName: placeName)
    }
}

//MARK: - UISearchBarDelegate

extension SearchNewMallViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchKeyword = searchBar.text else { return }
        viewModel.search(with: searchKeyword)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchNewMallViewController {
    
    private func configure() {
        title = "새 식당 등록"
        viewModel.delegate = self
        configureSearchBar()
        configureMapView()

    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "방문하신 매장을 검색해주세요"
    }
    
    private func configureMapView() {
        mapView = MTMapView()
        mapView.delegate = self
        mapView.baseMapType = .standard
        
        mapView.setMapCenter(
            MTMapPoint(geoCoord: viewModel.defaultLocation),
            zoomLevel: 1,
            animated: true
        )
        
        
        
    }
}

