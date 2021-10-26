import Foundation

struct NewProductDTO: Encodable {
    
    let createdBy: String
    let productCategoryId: Int
    let name: String
    let price: Int
    let file: Data
    
    init(productCategoryId: Int, name: String, price: Int, file: Data) {
        self.createdBy = User.shared.userUid
        self.productCategoryId = productCategoryId
        self.name = name
        self.price = price
        self.file = file
    }
}
