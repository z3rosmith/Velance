import Foundation

protocol CommunityDetailViewModelDelegate: AnyObject {
    func didFetchDetailInfo()
}

class CommunityDetailViewModel {
    
    weak var delegate: CommunityDetailViewModelDelegate?
    
    
//    private var replies: [UserFeedResponseDTO] = []
    var hasMore: Bool = true
    var isFetchingReply: Bool = false
    private var lastReplyID: Int?
}
