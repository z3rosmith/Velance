import Foundation

struct ProductListResponseDTO: Decodable {
    
    let productId: Int
    let name: String
    let price: Int
    let rating: Double
    let productCategory: ProductCategory
    let productVegetarianGroups: [ProductVegetarianGroups]            // 프론트에서 쓸 일은 없을 듯 -> 내 채식유형 필터링 할 때 사용될 예정
    let productAllergyGroups: [ProductAllergyGroups]
    
    let user: UserDisplayModel
    let fileFolder: FileFolder
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case name, price, rating
        case productCategory, user, fileFolder, productVegetarianGroups, productAllergyGroups
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



