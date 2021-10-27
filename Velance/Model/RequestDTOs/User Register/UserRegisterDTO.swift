import Foundation
import Alamofire

struct UserRegisterDTO {

    var parameters: Parameters = [:]
    
    init(username: String, displayName: String, password: String, vegetarianTypeId: String, tasteTypeIds: [String], interestTypeIds: [String], allergyTypeIds: [String]?) {
        
        parameters["user_name"] = username
        parameters["display_name"] = displayName
        parameters["password"] = password
        
        parameters["vegetarian_type_id"] = vegetarianTypeId
        parameters["taste_type_ids"] = tasteTypeIds
        parameters["interest_type_ids"] = interestTypeIds
        
        if let allergyTypeIds = allergyTypeIds {
            parameters["allergy_type_ids"] = allergyTypeIds
        }
        
    }
    
    
}
