import Foundation

protocol CommunityHeaderViewModelDelegate: AnyObject {
    
    func didFetchUsers()
}

class CommunityHeaderViewModel {
    
    weak var delegate: CommunityHeaderViewModelDelegate?
    
    private var recommendedUsers: [UserDisplayModel] = []
    
    var numberOfUsers: Int {
        return recommendedUsers.count
    }
    
    func userAtIndex(_ index: Int) -> CommunityHeaderCellViewModel {
        let user = recommendedUsers[index]
        return CommunityHeaderCellViewModel(user)
    }
}

class CommunityHeaderCellViewModel {
    
    private let user: UserDisplayModel
    
    init(_ user: UserDisplayModel) {
        self.user = user
    }
    
    var username: String {
        return user.displayName
    }
    
    var userType: String {
        return user.vegetarianType?.name ?? "-"
    }
    
    var userProfileImageURL: URL? {
        if let files = user.fileFolder?.files, files.count > 0 {
            return try? files[0].path.asURL()
        }
        return nil
    }
}

extension CommunityHeaderViewModel {
    
    func fetchRecommendedUser(byTaste: Bool) {
        UserManager.shared.fetchRecommendUser(byTaste: byTaste) { [weak self] result in
            switch result {
            case .success(let data):
                self?.recommendedUsers = data
            case .failure:
                return
            }
        }
    }
}
