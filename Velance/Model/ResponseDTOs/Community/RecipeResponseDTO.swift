import Foundation

// MARK: - RecipeResponseDTO
struct RecipeResponseDTO: Decodable {
    let recipeID: Int
    let title, contents: String
    let fileFolder: FileFolder?
    let recipeCategory: RecipeCategory
    let feed: Feed?
    let isLike: String?

    enum CodingKeys: String, CodingKey {
        case recipeID = "recipe_id"
        case title, contents, fileFolder, recipeCategory, feed
        case isLike = "is_like"
    }
}
