import Foundation

protocol CommunityDailyLifeListViewModelDelegate: AnyObject {
    func didFetchPostList()
}

/// post는 recipe의 일반적인 용어로 사용하였음
class CommunityDailyLifeListViewModel {
    weak var delegate: CommunityDailyLifeListViewModelDelegate?
    var posts: [DailyLifeResponseDTO] = []
    var hasMore: Bool = true
    var isFetchingData: Bool = false
    private var lastPostID: Int?
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
    
    func refreshPostList(interestTypeIDs: [Int]? = nil, viewOnlyFollowing: Bool = false) {
        self.posts.removeAll(keepingCapacity: true)
        self.hasMore = true
        self.isFetchingData = false
        self.lastPostID = nil
        self.fetchPostList(interestTypeIDs: interestTypeIDs, viewOnlyFollowing: viewOnlyFollowing)
    }
    
    func resetPostList() {
        self.posts.removeAll()
        self.hasMore = true
        self.isFetchingData = false
        self.lastPostID = nil
    }
    
    func postAtIndex(_ index: Int) -> CommunityDailyLifeViewModel {
        let post = self.posts[index]
        return CommunityDailyLifeViewModel(post)
    }
    
    /// 최신순으로 보려면 recipeCategoryID = nil
    func fetchPostList(interestTypeIDs: [Int]? = nil, viewOnlyFollowing: Bool = false) {
        isFetchingData = true
        
        let onlyFollowing: String = viewOnlyFollowing ? "Y" : "N"
        let model = DailyLifeRequestDTO(requestUserID: User.shared.userUid,
                                        cursor: lastPostID,
                                        interestTypeIDs: interestTypeIDs,
                                        onlyFollowing: onlyFollowing)
        
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
}

extension CommunityDailyLifeViewModel {
    
    var contents: String {
        return self.post.contents
    }
    
    var userDisplayName: String {
        return self.post.feed.user.displayName
    }
    
    var feedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        guard let date = dateFormatter.date(from: self.post.feed.createdAt) else {
            print("❗️CommunityDailyLifeViewModel - feedDate error")
            return "시간표시오류"
        }
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    var imageURLs: [URL]? {
        guard let files = self.post.fileFolder?.files, files.count > 0 else {
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
        return post.feed.repliesCount
    }
    
    var like: Int {
        return post.feed.like
    }
    
    var vegetarianType: String {
        guard let type = post.feed.user.vegetarianType?.name else {
            return "선택안함"
        }
        return type
    }
    
    var isLike: Bool {
        guard let like = post.isLike else {
            return false
        }
        if like == "Y" {
            return true
        }
        return false
    }
}
