import Foundation

protocol MallListViewModelDelegate: AnyObject {
    func didFetchMallList()
}

class MallListViewModel {
    
    weak var delegate: MallListViewModelDelegate?
    private var malls: [MallResponseDTO] = []
    var hasMore: Bool = true
    var isFetchingData: Bool = false
    private var lastMallID: Int?
}

class MallViewModel {
    
    private var mall: MallResponseDTO
    
    init(_ mall: MallResponseDTO) {
        self.mall = mall
    }
}

extension MallListViewModel {
    
    var numberOfMalls: Int {
        return malls.count
    }
    
    func refreshMallList(mallPoint: MallPoint) {
        self.malls.removeAll(keepingCapacity: true)
        self.hasMore = true
        self.isFetchingData = false
        self.lastMallID = nil
        self.fetchMallList(mallPoint: mallPoint)
    }
    
    func resetMallList() {
        self.malls.removeAll()
        self.hasMore = true
        self.isFetchingData = false
        self.lastMallID = nil
    }
    
    func mallAtIndex(_ index: Int) -> MallViewModel {
        let mall = self.malls[index]
        return MallViewModel(mall)
    }
    
    func fetchMallList(mallPoint: MallPoint) {
        
        let model = MallRequestDTO(x: mallPoint.x,
                                   y: mallPoint.y,
                                   radius: mallPoint.radius,
                                   cursor: lastMallID)
        MallManager.shared.fetchMallList(with: model) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return }
                if data.isEmpty {
                    self.hasMore = false
                } else {
                    self.lastMallID = data.last?.mallID
                }
                self.malls.append(contentsOf: data)
                self.isFetchingData = false
                self.delegate?.didFetchMallList()
            case .failure:
                return
            }
        }
    }
}

extension MallViewModel {
    
    var mallName: String {
        return mall.placeName
    }
    
    var menuCount: Int {
        return mall.vegunMenuCount
    }
    
    var mallAddress: String {
        return mall.addressName
    }
    
    
}
