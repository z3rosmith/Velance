import Foundation

struct RecipeRequestDTO: Encodable {
    
    let cursor, recipeCategoryID: Int?
    let onlyFollowing: String
    
    init(cursor: Int? = nil, recipeCategoryID: Int? = nil, onlyFollowing: String) {
        self.cursor = cursor
        self.recipeCategoryID = recipeCategoryID
        self.onlyFollowing = onlyFollowing
    }
}
