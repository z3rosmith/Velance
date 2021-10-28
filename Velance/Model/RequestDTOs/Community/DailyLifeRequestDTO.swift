import Foundation

struct DailyLifeRequestDTO: Encodable {
    
    let requestUserID: String
    let cursor: Int?
    let interestTypeIDs: [Int]?
    let onlyFollowing: String
    
    init(requestUserID: String, cursor: Int? = nil, interestTypeIDs: [Int]? = nil, onlyFollowing: String) {
        self.requestUserID = requestUserID
        self.cursor = cursor
        self.interestTypeIDs = interestTypeIDs
        self.onlyFollowing = onlyFollowing
    }
}
