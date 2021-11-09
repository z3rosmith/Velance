import Foundation

protocol CommunityDailyLifeListViewModelDelegate: AnyObject {
    
    func didFetchPostList()
    func didDeleteFeed()
    func didCompleteReport()
    func didBlockUser()
    func failedUserRequest(with error: NetworkError)
    func didLike(indexPath: IndexPath)
    func didUnlike(indexPath: IndexPath)
}

/// post는 recipe의 일반적인 용어로 사용하였음
class CommunityDailyLifeListViewModel {
    
    weak var delegate: CommunityDailyLifeListViewModelDelegate?
    var posts: [DailyLifeResponseDTO] = []
    var hasMore: Bool = true
    var isFetchingData: Bool = false
    private var lastPostID: Int?
    var isDoingLike: Bool = false
}

class CommunityDailyLifeViewModel {
    
    private var post: DailyLifeResponseDTO
    
    init(_ post: DailyLifeResponseDTO) {
        self.post = post
    }
}

extension CommunityDailyLifeListViewModel {
    
    var numberOfPosts: Int {
        return posts.count
    }
    
    func refreshPostList(interestTypeIDs: [Int]? = nil, regionIds: [String]? = nil, viewOnlyFollowing: Bool = false) {
        resetPostList(keepingCapacity: true)
        fetchPostList(interestTypeIDs: interestTypeIDs, regionIds: regionIds, viewOnlyFollowing: viewOnlyFollowing)
    }
    
    func resetPostList(keepingCapacity: Bool) {
        posts.removeAll()
        hasMore = true
        isFetchingData = false
        lastPostID = nil
    }
    
    func postAtIndex(_ index: Int) -> CommunityDailyLifeViewModel {
        let post = self.posts[index]
        return CommunityDailyLifeViewModel(post)
    }
    
    /// 최신순으로 보려면 recipeCategoryID = nil
    func fetchPostList(interestTypeIDs: [Int]? = nil, regionIds: [String]? = nil, viewOnlyFollowing: Bool = false) {
        isFetchingData = true
        
        let onlyFollowing: String = viewOnlyFollowing ? "Y" : "N"
        let model = DailyLifeRequestDTO(
            cursor: lastPostID,
            interestTypeIDs: interestTypeIDs,
            regionIds: regionIds,
            onlyFollowing: onlyFollowing
        )
        
        CommunityManager.shared.fetchDailyLifeList(with: model) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return }
                if data.isEmpty {
                    self.hasMore = false
                } else {
                    self.lastPostID = data.last?.dailyLifeID
                }
                self.posts.append(contentsOf: data)
                self.isFetchingData = false
                self.delegate?.didFetchPostList()
            case .failure:
                return
            }
        }
    }
    
    func likeFeed(feedID: Int, indexPath: IndexPath) {
        isDoingLike = true
        CommunityManager.shared.likeFeed(feedID: feedID) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didLike(indexPath: indexPath)
            case .failure:
                return
            }
            self?.isDoingLike = false
        }
    }
    
    func unlikeFeed(feedID: Int, indexPath: IndexPath) {
        isDoingLike = true
        CommunityManager.shared.unlikeFeed(feedID: feedID) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didUnlike(indexPath: indexPath)
            case .failure:
                return
            }
            self?.isDoingLike = false
        }
    }
    
    func deleteMyDailyLifeFeed(feedId: Int) {
        
        CommunityManager.shared.deleteMyFeed(feedId: feedId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.delegate?.didDeleteFeed()
            case .failure(let error):
                self.delegate?.failedUserRequest(with: error)
            }
        }
    }
    
    func reportDailyLifeFeed(type: ReportType.Feed, feedId: Int) {
        
        let model = ReportDTO(reason: type.rawValue, feedId: feedId)
        
        ReportManager.shared.report(
            type: .feed(type),
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
    
    func blockUser(targetUserId: String) {
        
        ReportManager.shared.blockUser(targetUserId: targetUserId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.didBlockUser()
            case .failure(let error):
                self.delegate?.failedUserRequest(with: error)
            }
        
        }
        
    }
}

extension CommunityDailyLifeViewModel {
    
    var dailyLifeID: Int {
        return post.dailyLifeID
    }
    
    var contents: String {
        return post.contents
    }
    
    var userDisplayName: String {
        return post.feed?.user.displayName ?? "-"
    }
    
    var feedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        guard let createdAt = post.feed?.createdAt, let date = dateFormatter.date(from: createdAt) else {
            print("❗️CommunityDailyLifeViewModel - feedDate error")
            return "시간표시오류"
        }
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    var imageURLs: [URL]? {
        guard let files = post.fileFolder?.files, files.count > 0 else {
            return nil
        }
        let imageURLs: [URL] = files.map {
            do {
                let url = try $0.path.asURL()
                return url
            } catch {
                print("In CommunityDailyLifeViewModel - error converting string to url: \(error)")
                return nil
            }
        }.compactMap {
            $0
        }
        return imageURLs
    }
    
    var repliesCount: Int {
        return post.feed?.repliesCount ?? 0
    }
    
    var like: Int {
        return post.feed?.like ?? 0
    }
    
    var vegetarianType: String {
        guard let type = post.feed?.user.vegetarianType?.name else {
            return "선택안함"
        }
        return type
    }
    
    var isLike: Bool {
        return post.isLike ?? false
    }
    
    var feedId: Int {
        return post.feed?.feedID ?? 0
    }
    
    var userUid: String {
        return post.feed?.user.userUid ?? ""
    }
    
    var userProfileImageUrlString: String? {
        return post.feed?.user.fileFolder?.files[0].path ?? ""
    }
}
