import Foundation

struct UserRegisterValues {
    
    static var shared = UserRegisterValues()
    
    private init() {}

    var username: String = ""
    var displayName: String = ""
    var password: String = ""
    
    var vegetarianTypeId: String = ""
    var tasteTypeIds: [String] = []
    var interestTypeIds: [String] = []
    var allergyTypeIds: [String]?

    
}
