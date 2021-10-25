import Foundation

struct ProductListResponseDTO: Decodable {
    
    let productId: Int
    let name: String
    let price: Int
    let rating: Double
    let productCategory: ProductCategory
    let user: UserDisplayModel
    let fileFolder: FileFolder
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case name, price, rating
        case productCategory, user, fileFolder
    }
}

struct ProductCategory: Codable {
    let productCategoryID: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case productCategoryID = "product_category_id"
        case name
    }
}



