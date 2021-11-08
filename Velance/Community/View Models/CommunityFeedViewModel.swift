import Foundation
import AVFoundation

protocol CommunityFeedViewModelDelegate: AnyObject {

    func didFetchProfile()
    func didFetchUserFeedList()
}

class CommunityFeedViewModel {
    
    weak var delegate: CommunityFeedViewModelDelegate?
    private var userProfile: UserDisplayModel?
    private var posts: [UserFeedResponseDTO] = []
    var hasMore: Bool = true
    var isFetchingPost: Bool = false
    private var lastPostID: Int?
}

class CommunityFeedCellViewModel {
    
    private var post: UserFeedResponseDTO
    
    init(_ post: UserFeedResponseDTO) {
        self.post = post
    }
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
    
    var numberOfFeeds: Int {
        return posts.count
    }
    
    func feedAtIndex(_ index: Int) -> CommunityFeedCellViewModel {
        let feed = posts[index]
        return CommunityFeedCellViewModel(feed)
    }
    
    func fetchProfile(userUID: String) {
        UserManager.shared.fetchProfileForCommunity(userUID: userUID) { [weak self] result in
            switch result {
            case .success(let data):
                self?.userProfile = data
                self?.delegate?.didFetchProfile()
            case .failure:
                return
            }
        }
    }
    
    func fetchUserPostList(userUID: String) {
        CommunityManager.shared.fetchUserFeedList(userID: userUID, cursor: lastPostID) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return }
                if data.isEmpty {
                    self.hasMore = false
                } else {
                    self.lastPostID = data.last?.feedID
                }
                self.posts.append(contentsOf: data)
                self.isFetchingPost = false
                self.delegate?.didFetchUserFeedList()
            case .failure:
                return
            }
        }
    }
}

extension CommunityFeedCellViewModel {
    
    var isRecipe: Bool {
        if let _ = post.recipe {
            return true
        } else {
            return false
        }
    }
    
    var isDailyLife: Bool {
        if let _ = post.dailyLife {
            return true
        } else {
            return false
        }
    }
    
    var feedThumbnailURL: URL? {
        if isRecipe {
            if let files = post.recipe?.fileFolder?.files, files.count > 0 {
                return try? files[0].path.asURL()
            }
        }
        if isDailyLife {
            if let files = post.dailyLife?.fileFolder?.files, files.count > 0 {
                return try? files[0].path.asURL()
            }
        }
        return nil
    }
    
    /// isRecipe가 true인 경우에만 사용할것
    var recipeID: Int {
        return post.recipe!.recipeID
    }
    
    /// isDailyLife가 true인 경우에만 사용할것
    var dailyLifeID: Int {
        return post.dailyLife!.dailyLifeID
    }
}
