import Foundation

struct UserDisplayModel: Decodable {
    
    let userUid: String
    let userName, displayName: String
    let vegetarianType: VegetarianType?
    let fileFolder: FileFolder?
    let userTasteGroups: [UserTasteGroups]?
    let userInterestGroups: [UserInterestGroups]?
    let followers: Int?
    let followings: Int?
    let isFollowing: Bool?
    
    enum CodingKeys: String, CodingKey {
        case userUid = "user_id"
        case userName = "user_name"
        case displayName = "display_name"
        case vegetarianType, fileFolder, userTasteGroups, userInterestGroups
        case followers = "followerCount"
        case followings = "followingCount"
        case isFollowing = "is_following"
    }
}
