import Foundation

protocol CommunityFeedViewModelDelegate {

    func didFetchProfile()
}

class CommunityFeedViewModel {
    
    var delegate: CommunityFeedViewModelDelegate?
    var userProfile: UserDisplayModel?
}

extension CommunityFeedViewModel {
    
    var username: String {
        return userProfile?.displayName ?? "error"
    }
    
    var userVegetarianType: String {
        return userProfile?.vegetarianType?.name ?? "error"
    }
    
    var userInterestType: [String] {
        return userProfile?.userInterestGroups?.map {
            " \($0.interestType.name) "
        } ?? ["error"]
    }
    
    var followings: Int {
        return userProfile?.followings ?? -1
    }
    
    var followers: Int {
        return userProfile?.followers ?? -1
    }
    
    var userImageURL: URL? {
        return try? userProfile?.fileFolder?.files[0].path.asURL()
    }
    
    func fetchProfile(userUID: String) {
        UserManager.shared.fetchProfileForCommunity(userUID: userUID) { result in
            switch result {
            case .success(let data):
                self.userProfile = data
                self.delegate?.didFetchProfile()
            case .failure:
                return
            }
        }
    }
}
