import Foundation

struct NewReviewDTO: Encodable {
    
    let productId: Int
    let createdBy: String
    let rating: Int
    let contents: String
    let files: [Data]
    
    init(productId: Int, rating: Int, contents: String, files: [Data]) {
        self.productId = productId
        self.createdBy = User.shared.userUid
        self.rating = rating
        self.contents = contents
        self.files = files
    }
    
}
