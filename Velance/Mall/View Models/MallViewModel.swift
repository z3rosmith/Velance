import Foundation

protocol MallViewModelDelegate: AnyObject {
    func didFetchMenuList()
    func failedFetchingMenuList(with error: NetworkError)
    func didCompleteReport()
    
    func didLikeMenu(at indexPath: IndexPath)
    func didCancelLikeMenu(at indexPath: IndexPath)
    func failedUserRequest(with error: NetworkError)
}

class MallViewModel {
    
    weak var delegate: MallViewModelDelegate?
    
    // 수정
    var mallId: Int?
    
    var menuList: [MallMenuResponseDTO] = []
    
    var isFetchingData: Bool = false
    var page: Int = 0
    
    func fetchMenuList() {
        showProgressBar()
        isFetchingData = true
        
        MallManager.shared.getMallMenuList(
            page: page,
            mallId: mallId ?? 1
        ) { [weak self] result in
            guard let self = self else { return }
            dismissProgressBar()
            switch result {
            case .success(let menuList):
                if menuList.isEmpty {
                    self.delegate?.didFetchMenuList()
                    return
                }
                self.page = menuList.last?.menuId ?? 0
                self.isFetchingData = false
                self.menuList.append(contentsOf: menuList)
                self.delegate?.didFetchMenuList()
                
            case .failure(let error):
                self.isFetchingData = false
                self.delegate?.failedFetchingMenuList(with: error)
                
            }
        }
    }
    
    //MARK: - 메뉴 좋아요
    
    func likeMenu(menuId: Int, indexPath: IndexPath) {
        
        MallManager.shared.likeMenu(menuId: menuId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: self.delegate?.didLikeMenu(at: indexPath)
            case .failure(let error):  self.delegate?.failedUserRequest(with: error)
            }
        }
    }
    
    func cancelLikeMenu(menuId: Int, indexPath: IndexPath) {
        
        MallManager.shared.cancelLikeMenu(menuId: menuId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: self.delegate?.didCancelLikeMenu(at: indexPath)
            case .failure(let error): self.delegate?.failedUserRequest(with: error)
            }
        }
        
    }
    
    func reportReview(type: ReportType.Mall) {
        
        let model = ReportDTO(reason: type.rawValue, mallId: mallId ?? 0)
        
        ReportManager.shared.report(
            type: .mall(type),
            model: model
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.didCompleteReport()
            case .failure(let error):
                self.delegate?.failedUserRequest(with: error)
            }
        }
    }

}

//MARK: - Refresh & Reset Methods

extension MallViewModel {
    
    func refreshTableView() {
        resetValues()
        fetchMenuList()
    }
    
    func resetValues() {
        menuList.removeAll()
        isFetchingData = false
        page = 0
    }
}
