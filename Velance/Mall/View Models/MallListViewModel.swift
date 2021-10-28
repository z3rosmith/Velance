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

class MallCellViewModel {
    
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
    
    func mallAtIndex(_ index: Int) -> MallCellViewModel {
        let mall = self.malls[index]
        return MallCellViewModel(mall)
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

extension MallCellViewModel {
    
    var mallName: String {
        return mall.placeName
    }
    
    var menuCount: Int {
        return mall.vegunMenuCount
    }
    
    var mallAddress: String {
        guard let addressName = mall.addressName else {
            print("MallCellViewModel - mallAddress - error")
            return "주소표시오류  "
        }
        return addressName
    }
    
    var imageURL: URL? {
        guard let files = mall.fileFolder?.files, files.count > 0 else {
            return nil
        }
        do {
            let url = try files.first?.path.asURL()
            return url
        } catch {
            print("In MallCellViewModel - error converting string to url: \(error)")
            return nil
        }
    }
    
    var onlyVegan: Bool {
        return mall.onlyVegan == "N" ? false : true
    }
}
