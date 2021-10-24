import Foundation
import Alamofire
import SwiftyJSON

class ProductManager {
    
    static let shared = ProductManager()
    
    let interceptor = Interceptor()
    
    //MARK: - End Points
    let getProductUrl       = "\(API.baseUrl)product"
    
    func getProducts(
        page: Int,
        productCategoryId: Int,
        onlyMyVegetarianType: String = "N",
        completion: @escaping ((Result<[ProductListResponseDTO], NetworkError>) -> Void)
    ) {
        
        let parameters: Parameters = [
            "request_user_id": User.shared.userUid,
            "page": page,
            "product_category_id": productCategoryId,
            "only_my_vegetarian_type": onlyMyVegetarianType
        ]
        
        AF.request(
            getProductUrl,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.queryString,
            interceptor: interceptor
        )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(_):
                    print("✏️ ProductManager - getProducts SUCCESS")
                    do {
                        let decodedData = try JSONDecoder().decode([ProductListResponseDTO].self, from: response.data!)
                        completion(.success(decodedData))
                    } catch {
                        print("❗️ ProductManager - getProducts Decoding ERROR: \(error)")
                        completion(.failure(.internalError))
                    }
                case .failure(_):
                    completion(.failure(.internalError))
                }
                
            }
    
        
    }
}
