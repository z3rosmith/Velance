import Foundation

struct UserDisplayModel: Decodable {
    
    let userId, userName, displayName: String
    let vegetarianType: VegetarianType?
    let fileFolder: FileFolder?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case displayName = "display_name"
        case vegetarianType, fileFolder
    }
}


