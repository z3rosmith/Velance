import Foundation
import AVFoundation

protocol CommunityFeedViewModelDelegate: AnyObject {

    func didFetchProfile()
    func didFetchUserFeedList()
    func didFollow()
    func didUnfollow()
}

class CommunityFeedViewModel {
    
    weak var delegate: CommunityFeedViewModelDelegate?
    private var userProfile: UserDisplayModel?
    private var posts: [UserFeedResponseDTO] = []
    var hasMore: Bool = true
    var isFetchingPost: Bool = false
    private var lastPostID: Int?
    var isFollowing: Bool = false
    
    func feedAtIndex(_ index: Int) -> CommunityFeedCellViewModel {
        let feed = posts[index]
        return CommunityFeedCellViewModel(feed)
    }
}

class CommunityFeedCellViewModel {
    
    private var post: UserFeedResponseDTO
    
    init(_ post: UserFeedResponseDTO) {
        self.post = post
    }
}

extension CommunityFeedViewModel {
    
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
    
    func refreshUserPostList(userUID: String) {
        posts.removeAll(keepingCapacity: true)
        hasMore = true
        isFetchingPost = false
        lastPostID = nil
        fetchUserPostList(userUID: userUID)
    }
    
    func fetchUserPostList(userUID: String) {
        isFetchingPost = true
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
    
    func followUser(targetUID: String) {
        isFollowing = true
        CommunityManager.shared.folllowUser(targetUID: targetUID) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didFollow()
            case .failure:
                return
            }
            self?.isFollowing = false
        }
    }
    
    func unfollowUser(targetUID: String) {
        isFollowing = true
        CommunityManager.shared.unfollowUser(targetUID: targetUID) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didUnfollow()
            case .failure:
                return
            }
            self?.isFollowing = false
        }
    }
    
    var username: String {
        return userProfile?.displayName ?? "-"
    }
    
    var userVegetarianType: String {
        return userProfile?.vegetarianType?.name ?? "-"
    }
    
    var userInterestType: [String] {
        return userProfile?.userInterestGroups?.map {
            " \($0.interestType.name) "
        } ?? ["-"]
    }
    
    var followings: Int {
        return userProfile?.followings ?? 0
    }
    
    var followers: Int {
        return userProfile?.followers ?? 0
    }
    
    var userImageURL: URL? {
        return try? userProfile?.fileFolder?.files[0].path.asURL()
    }
    
    var numberOfFeeds: Int {
        return posts.count
    }
}

extension CommunityFeedCellViewModel {
    
    var isRecipe: Bool {
        if let _ = post.recipe {
            return true
        } else if let _ = post.dailyLife {
            return false
        } else {
            return true // 사실 이 일은 일어나지 않음
        }
    }
    
    var feedThumbnailURL: URL? {
        if isRecipe {
            if let files = post.recipe?.fileFolder?.files, files.count > 0 {
                return try? files[0].path.asURL()
            }
        } else {
            if let files = post.dailyLife?.fileFolder?.files, files.count > 0 {
                return try? files[0].path.asURL()
            }
        }
        return nil
    }
    
    /// isRecipe가 true인 경우에만 사용할것
    var recipeID: Int {
        return post.recipe?.recipeID ?? -1
    }
    
    /// isRecipe가 false인 경우에만 사용할것
    var dailyLifeID: Int {
        return post.dailyLife?.dailyLifeID ?? -1
    }
}
