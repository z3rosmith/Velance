import Foundation

// MARK: - RecipeCategory
struct RecipeCategory: Decodable {
    let recipeCategoryID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case recipeCategoryID = "recipe_category_id"
        case name
    }
}
