import Foundation

protocol CommunityDetailViewModelDelegate: AnyObject {
    func didFetchDetailInfo()
    func didFetchReplies()
    func didPostReply()
    func didLike()
    func didUnlike()
    
    func didDeleteReply()
    func didCompleteReport()
    func didBlockUser()
    func failedUserRequest(with error: NetworkError)
}

class CommunityDetailViewModel {
    
    weak var delegate: CommunityDetailViewModelDelegate?
    
    private var post: FeedDetailResponseDTO?
    private var replies: [ReplyResponseDTO] = []
    var hasMore: Bool = true
    var isFetchingReply: Bool = false
    private var lastReplyID: Int?
    var isDoingLike: Bool = false
    
    func replyAtIndex(_ index: Int) -> CommunityDetailReplyViewModel {
        let reply = replies[index]
        return CommunityDetailReplyViewModel(reply)
    }
}

class CommunityDetailReplyViewModel {
    
    private var reply: ReplyResponseDTO
    
    init(_ reply: ReplyResponseDTO) {
        self.reply = reply
    }
}

extension CommunityDetailViewModel {
    
    func likeFeed() {
        guard let feedID = post?.feed?.feedID else { return }
        isDoingLike = true
        CommunityManager.shared.likeFeed(feedID: feedID) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didLike()
            case .failure:
                return
            }
            self?.isDoingLike = false
        }
    }
    
    func unlikeFeed() {
        guard let feedID = post?.feed?.feedID else { return }
        isDoingLike = true
        CommunityManager.shared.unlikeFeed(feedID: feedID) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didUnlike()
            case .failure:
                return
            }
            self?.isDoingLike = false
        }
    }
    
    func fetchPostInfo(isRecipe: Bool, id: Int) {
        CommunityManager.shared.fetchPostDetail(isRecipe: isRecipe, id: id) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return }
                self.post = data
                self.delegate?.didFetchDetailInfo()
            case .failure:
                return
            }
        }
    }
    
    func fetchReplies() {
        guard let feedID = post?.feed?.feedID else {
            print("Empty post...")
            return
        }
        
        isFetchingReply = true
        
        CommunityManager.shared.fetchReplies(feedID: feedID, cursor: lastReplyID) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else { return }
                if data.isEmpty {
                    self.hasMore = false
                } else {
                    self.lastReplyID = data.last?.replyID
                }
                self.replies.append(contentsOf: data)
                self.isFetchingReply = false
                self.delegate?.didFetchReplies()
            case .failure:
                return
            }
        }
    }
    
    func refreshReplies() {
        replies.removeAll(keepingCapacity: true)
        hasMore = true
        isFetchingReply = false
        lastReplyID = nil
        fetchReplies()
    }
    
    func postReply(feedID: Int, contents: String) {
        CommunityManager.shared.postReply(feedID: feedID, contents: contents) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didPostReply()
                return
            case .failure:
                return
            }
        }
    }

    func deleteMyDailyLifeFeed(replyId: Int) {
        
        CommunityManager.shared.deleteMyReply(replyId: replyId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.delegate?.didDeleteReply()
            case .failure(let error):
                self.delegate?.failedUserRequest(with: error)
            }
        }
    }
    
    func reportReply(type: ReportType.Reply, replyId: Int) {
        
        let model = ReportDTO(reason: type.rawValue, replyId: replyId)
        

        ReportManager.shared.report(
            type: .reply(type),
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
    
    var numberOfReplies: Int {
        return replies.count
    }
    
    var contents: String {
        return post?.contents ?? "-"
    }
    
    var feedID: Int? {
        return post?.feed?.feedID
    }
    
    var feedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        guard let createdAt = post?.feed?.createdAt, let date = dateFormatter.date(from: createdAt) else {
            return "-"
        }
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    var userProfileImageURL: URL? {
        if let files = post?.feed?.user.fileFolder?.files, files.count > 0 {
            return try? files[0].path.asURL()
        }
        return nil
    }
    
    var imageURLs: [URL]? {
        guard let files = post?.fileFolder?.files, files.count > 0 else {
            return nil
        }
        let imageURLs: [URL] = files.map {
            do {
                let url = try $0.path.asURL()
                return url
            } catch {
                print("In CommunityDetailViewModel - error converting string to url: \(error)")
                return nil
            }
        }.compactMap {
            $0
        }
        return imageURLs
    }
    
    var username: String {
        return post?.feed?.user.displayName ?? "-"
    }
    
    var likeCount: Int {
        return post?.feed?.like ?? 0
    }
    
    var repliesCount: Int {
        return post?.feed?.repliesCount ?? 0
    }
    
    var isLike: Bool {
        return post?.isLike ?? false
    }
}

extension CommunityDetailReplyViewModel {
    
    var replyID: Int {
        return reply.replyID
    }
    
    var contents: String {
        return reply.contents
    }
    
    var replyTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        guard let date = dateFormatter.date(from: reply.createdAt) else {
            return "-"
        }
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    var username: String {
        return reply.user.displayName
    }
    
    var userProfileImageURL: URL? {
        if let files = reply.user.fileFolder?.files, files.count > 0 {
            return try? files[0].path.asURL()
        }
        return nil
    }
    
    var createdBy: String {
        return reply.user.userUid
    }
}
