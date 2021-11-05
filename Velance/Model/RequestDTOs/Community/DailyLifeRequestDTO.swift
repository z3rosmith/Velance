import Foundation

struct DailyLifeRequestDTO: Encodable {

    let cursor: Int?
    let interestTypeIDs: [Int]?
    let onlyFollowing: String
    
    init(cursor: Int? = nil, interestTypeIDs: [Int]? = nil, onlyFollowing: String) {
        self.cursor = cursor
        self.interestTypeIDs = interestTypeIDs
        self.onlyFollowing = onlyFollowing
    }
}
