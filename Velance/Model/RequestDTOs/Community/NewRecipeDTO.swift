import Foundation

struct NewRecipeDTO: Encodable {
    
    let title: String
    let contents: String
    let files: [Data]
    let recipeCategoryId: Int
    
    init(title: String, contents: String, files: [Data], recipeCategoryId: Int) {
        self.title = title
        self.contents = contents
        self.files = files
        self.recipeCategoryId = recipeCategoryId
    }
}
