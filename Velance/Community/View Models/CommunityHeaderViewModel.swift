import Foundation

protocol CommunityHeaderViewModelDelegate: AnyObject {
    
    func didFetchUsers()
    func didFollow()
    func didUnfollow()
}

class CommunityHeaderViewModel {
    
    weak var delegate: CommunityHeaderViewModelDelegate?
    
    private var recommendedUsers: [UserDisplayModel] = []
    
    var isDoingFollow: Bool = false
    
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
    
    var userUID: String {
        return user.userUid
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
    
    var isFollow: Bool {
        return user.isFollowing ?? false
    }
}

extension CommunityHeaderViewModel {
    
    func fetchRecommendedUser(byTaste: Bool) {
        UserManager.shared.fetchRecommendUser(byTaste: byTaste) { [weak self] result in
            switch result {
            case .success(let data):
                self?.recommendedUsers = data
                self?.delegate?.didFetchUsers()
            case .failure:
                return
            }
        }
    }
    
    func followUser(targetUID: String) {
        isDoingFollow = true
        CommunityManager.shared.folllowUser(targetUID: targetUID) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didFollow()
            case .failure:
                return
            }
            self?.isDoingFollow = false
        }
    }
    
    func unfollowUser(targetUID: String) {
        isDoingFollow = true
        CommunityManager.shared.unfollowUser(targetUID: targetUID) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didUnfollow()
            case .failure:
                return
            }
            self?.isDoingFollow = false
        }
    }
}
