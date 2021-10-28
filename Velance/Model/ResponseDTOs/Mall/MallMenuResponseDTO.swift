import Foundation

struct MallMenuResponseDTO: Decodable {
    
    let menuId: Int
    let name: String
    let price: Int
    let caution: String?
    let isVegan: String
    let likeCount: Int
    let dislikeCount: Int
    let fileFolder: FileFolder
    
    enum CodingKeys: String, CodingKey {
        case menuId = "menu_id"
        case name, price, caution
        case isVegan = "is_vegan"
        case likeCount = "like_count"
        case dislikeCount = "dislike_count"
        case fileFolder
    }
}
