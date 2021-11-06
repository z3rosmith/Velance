import Foundation
import Alamofire

struct UserInfoUpdateDTO {
    
    var parameters: Parameters = [:]
    
    init(vegetarianTypeId: String, tasteTypeIds: [String], interestTypeIds: [String]?, allergyTypeIds: [String]?) {
        
        parameters["vegetarian_type_id"] = vegetarianTypeId
        parameters["taste_type_ids"] = tasteTypeIds
        
        if let interestTypeIds = interestTypeIds {
            parameters["interest_type_ids"] = interestTypeIds
        }
        
        if let allergyTypeIds = allergyTypeIds {
            parameters["allergy_type_ids"] = allergyTypeIds
        }
        
        print("✏️ PARAMETERS: \(self.parameters)")
    }
}
