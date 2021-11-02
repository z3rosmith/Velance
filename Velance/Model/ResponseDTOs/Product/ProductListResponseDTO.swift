import Foundation

struct ProductListResponseDTO: Decodable {
    
    let productId: Int
    let productListReportNumber: String?
    let name: String
    let price: Int
    let rating: Double
    let productAllergyGroups: [ProductAllergyGroups]?

    let user: UserDisplayModel
    let fileFolder: FileFolder
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productListReportNumber = "PRDLST_REPORT_NO"
        case name, price, rating
        case user, fileFolder
        case productAllergyGroups
    }
}

struct ProductVegetarianGroups: Decodable {
    
    let productVegetarianGroupId: Int
    let vegetarianType: VegetarianType
    
    enum CodingKeys: String, CodingKey {
        case productVegetarianGroupId = "product_vegetarian_group_id"
        case vegetarianType
    }
}

struct ProductAllergyGroups: Decodable {
    
    let productAllergyGroupId: Int
    let allergyType: AllergyType
    
    enum CodingKeys: String, CodingKey {
        case productAllergyGroupId = "product_allergy_group_id"
        case allergyType
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



