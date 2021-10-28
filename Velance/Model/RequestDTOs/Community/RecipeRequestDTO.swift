import Foundation

struct RecipeRequestDTO: Encodable {
    
    let requestUserID: String
    let cursor, recipeCategoryID: Int?
    let onlyFollowing: String
    
    init(requestUserID: String, cursor: Int? = nil, recipeCategoryID: Int? = nil, onlyFollowing: String) {
        self.requestUserID = requestUserID
        self.cursor = cursor
        self.recipeCategoryID = recipeCategoryID
        self.onlyFollowing = onlyFollowing
    }
}
