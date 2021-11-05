import Foundation

struct NewReviewDTO: Encodable {
    
    let productId: Int
    let rating: Int
    let contents: String
    let files: [Data]
    
    init(productId: Int, rating: Int, contents: String, files: [Data]) {
        self.productId = productId
        self.rating = rating
        self.contents = contents
        self.files = files
    }
    
}
