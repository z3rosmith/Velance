import Foundation

struct UserTasteGroups: Decodable {
    
    let userTasteGroupId: Int
    let tasteType: TasteType

    enum CodingKeys: String, CodingKey {
        case userTasteGroupId = "user_taste_group_id"
        case tasteType
    }
}

struct TasteType: Decodable {
    
    let tasteTypeId: Int
    let name: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case tasteTypeId = "taste_type_id"
        case name, description
    }
    
}
