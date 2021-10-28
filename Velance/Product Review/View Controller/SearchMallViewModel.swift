import Foundation

protocol SearchMallViewModelDelegate: AnyObject {
    func didFetchSearchResults()
    func failedFetchingSearchResults(with error: NetworkError)
}

class SearchMallViewModel {
    
    weak var delegate: SearchMallViewModelDelegate?
    
    let defaultLocation = MTMapPointGeo(latitude: 37.497866841186955, longitude: 127.02753316658152)
    
    
    /// 검색어에 검색된 문서 수
    var totalCount: Int = 0
    
    /// /// 장소명, 업체명
    var placeName: [String] = []
    
    var address: [String] = []
    
    var placeID: [String] = []
    
    var documents: [SearchedMallInfo] = []
    
    var currentlySelectedIndex: Int?
    
    var mallDetails = MallDetailFromKakao()
    
    func search(with keyword: String) {
        
        resetSearchResults()
        let searchModel = SearchMallDTO(query: keyword)
        
        MapManager.shared.searchByKeyword(with: searchModel) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                
                self.documents = result.documents
                
                for result in result.documents {
                    self.placeName.append(result.placeName)
                    self.address.append(result.address)
                    self.placeID.append(result.id)
                }
                
                self.totalCount = self.placeName.count
                self.delegate?.didFetchSearchResults()
                
            case .failure(let error):
                self.delegate?.failedFetchingSearchResults(with: error)
            }
        }
    }
    
    
    func fetchLocation(of index: Int) -> (Double, Double, String) {
        
        let placeName = documents[index].placeName
        currentlySelectedIndex = index
        
        if let x = Double(documents[index].x), let y = Double(documents[index].y) {
            mallDetails.longitude = x
            mallDetails.latitude = y
            return (x, y, placeName)
        }
        
        print("SearchResViewModel - Location unavailable")

        /// 기본값 반환 (경북대 중앙)
        let x = 127.02753316658152       /// longitude
        let y = 37.497866841186955      /// latitude
        return (x, y, placeName)
    }
    
    func resetSearchResults() {
        
        placeName.removeAll()
        address.removeAll()
    }
    
    
    func getRestaurantDetails(for index: Int) -> MallDetailFromKakao {
        
        mallDetails.placeID = placeID[index]
        mallDetails.name = placeName[index]
        mallDetails.address = documents[index].address
        mallDetails.contact = documents[index].contact
        mallDetails.category = documents[index].categoryName
        mallDetails.longitude = Double(documents[index].x)!
        mallDetails.latitude = Double(documents[index].y)!
        
        return mallDetails
    }
}
