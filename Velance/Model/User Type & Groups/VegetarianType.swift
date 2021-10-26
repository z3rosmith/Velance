import Foundation

struct VegetarianType: Decodable {
    
    let vegetarianTypeId: Int
    let name: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case vegetarianTypeId = "vegetarian_type_id"
        case name, description
    }
}
