import Foundation

struct UserDisplayModel: Codable {
    
    let userId, userName, displayName: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case displayName = "display_name"
        
    }
}


