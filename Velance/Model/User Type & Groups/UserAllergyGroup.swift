import Foundation

struct UserAllergyGroup: Decodable {
    
    let userAllergyGroupId: Int
    let allergyType: TasteType

    enum CodingKeys: String, CodingKey {
        case userAllergyGroupId = "user_allergy_group_id"
        case allergyType
    }
}

struct AllergyType: Decodable {
    
    let allergyTypeId: Int
    let name: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case allergyTypeId = "allergy_type_id"
        case name, description
    }
    
}
