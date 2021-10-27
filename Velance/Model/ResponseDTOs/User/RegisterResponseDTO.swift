import Foundation

struct RegisterResponseDTO: Decodable {
    
    let userId: String
    let username: String
    let displayName: String
    let vegetarianType: VegetarianType
    let userTasteGroups: [UserTasteGroups]
    let userInterestGroups: [UserInterestGroups]
    let userAllergyGroups: [UserAllergyGroup]?
}
