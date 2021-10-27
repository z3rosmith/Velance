import Foundation

struct ProductReviewResponseDTO: Decodable {
    
    let reviewId: Int
    var createdAt: String
    let rating: Int
    let contents: String
    let fileFolder: FileFolder
    let user: UserDisplayModel

    enum CodingKeys: String, CodingKey {
        case reviewId = "review_id"
        case createdAt = "created_at"
        case rating, contents, fileFolder, user
    }
}

extension ProductReviewResponseDTO {
    
    var formattedDate: String {
        return createdAt.getFormattedDateString()
    }
}
