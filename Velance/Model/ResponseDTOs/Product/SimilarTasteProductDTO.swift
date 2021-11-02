import Foundation

struct SimilarTasteProductDTO: Decodable {
    
    let productId: Int
    let productListReportNumber: String?
    let name: String
    let price: Int
    let rating: Double
    let fileFolder: FileFolder
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case productListReportNumber = "PRDLST_REPORT_NO"
        case name, price, rating, fileFolder
    }
}
