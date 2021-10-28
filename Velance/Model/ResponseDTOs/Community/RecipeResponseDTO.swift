import Foundation

// MARK: - RecipeResponseDTO
struct RecipeResponseDTO: Decodable {
    let recipeID: Int
    let title, contents: String
    let fileFolder: FileFolder?
    let recipeCategory: RecipeCategory
    let feed: Feed

    enum CodingKeys: String, CodingKey {
        case recipeID = "recipe_id"
        case title, contents, fileFolder, recipeCategory, feed
    }
}
