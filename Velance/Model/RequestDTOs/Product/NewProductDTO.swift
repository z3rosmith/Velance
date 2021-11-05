import Foundation

struct NewProductDTO: Encodable {
    
    let productCategoryId: Int
    let name: String
    let price: Int
    let file: Data
    
    init(productCategoryId: Int, name: String, price: Int, file: Data) {
        self.productCategoryId = productCategoryId
        self.name = name
        self.price = price
        self.file = file
    }
}
