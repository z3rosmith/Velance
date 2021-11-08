import Foundation

struct DailyLifeRequestDTO: Encodable {

    let cursor: Int?
    let interestTypeIDs: [Int]?
    let regionsIds: [String]?
    let onlyFollowing: String
    
    init(cursor: Int? = nil, interestTypeIDs: [Int]? = nil, regionIds: [String]? = nil, onlyFollowing: String) {
        self.cursor = cursor
        self.interestTypeIDs = interestTypeIDs
        self.regionsIds = regionIds
        self.onlyFollowing = onlyFollowing
    }
}
