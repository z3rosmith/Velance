import Foundation

struct FeedDetailResponseDTO: Decodable {
    
    let recipeID: Int?
    let dailyLifeID: Int?
    let title, contents: String
    let fileFolder: FileFolder?
    let recipeCategory: RecipeCategory?
    let feed: Feed?
    let isLike: String?

    enum CodingKeys: String, CodingKey {
        case recipeID = "recipe_id"
        case dailyLifeID = "daily_life_id"
        case title, contents, fileFolder, recipeCategory, feed
        case isLike = "is_like"
    }
}
