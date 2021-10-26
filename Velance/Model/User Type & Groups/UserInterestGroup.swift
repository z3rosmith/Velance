import Foundation

struct UserInterestGroup: Decodable {
    
    let userInterestGroupId: Int
    let interestType: InterestType
    
    enum CodingKeys: String, CodingKey {
        case userInterestGroupId = "user_interest_group_id"
        case interestType
    }
    
}

struct InterestType: Decodable {
    
    let interestTypeId: Int
    let name: String
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case interestTypeId = "interest_type_id"
        case name, description
    }
    
}
