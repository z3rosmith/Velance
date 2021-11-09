import Foundation

struct UserDisplayModel: Decodable {
    
    let userUid, userName, displayName: String
    let vegetarianType: VegetarianType?
    let fileFolder: FileFolder?
    let userTasteGroups: [UserTasteGroups]?
    let userInterestGroups: [UserInterestGroups]?
    let followerCount: Int?
    let followingCount: Int?
    let isFollowing: Bool?
    
    enum CodingKeys: String, CodingKey {
        case userUid = "user_id"
        case userName = "user_name"
        case displayName = "display_name"
        case vegetarianType, fileFolder, userTasteGroups, userInterestGroups, followerCount, followingCount
        case isFollowing = "is_following"
    }
}
