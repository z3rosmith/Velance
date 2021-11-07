import Foundation

struct UserFeedResponseDTO: Decodable {
    
    let feedID: Int
    let createdAt: String
    let user: UserDisplayModel
    let recipe: RecipeResponseDTO?
    let dailyLife: DailyLifeResponseDTO?
    
    enum CodingKeys: String, CodingKey {
        case feedID = "feed_id"
        case createdAt = "created_at"
        case user, recipe, dailyLife
    }
}
