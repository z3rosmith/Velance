import Foundation

struct UserRegisterDTO {

    let username: String
    let displayName: String
    let password: String
    
    let vegetarianTypeId: String
    let tasteTypeIds: [String]
    let interestTypeIds: [String]
    var allergyTypeIds: [String]?
    
    init(username: String, displayName: String, password: String, vegetarianTypeId: String, tasteTypeIds: [String], interestTypeIds: [String], allergyTypeIds: [String]?) {

        self.username = username
        self.displayName = displayName
        self.password = password
        
        self.vegetarianTypeId = vegetarianTypeId
        self.tasteTypeIds = tasteTypeIds
        self.interestTypeIds = interestTypeIds
        self.allergyTypeIds = allergyTypeIds
    }
    
    
}
