import Foundation

extension UserDefaults {
    
    enum Keys {
        
        static let accessToken      = "accessToken"
        static let refreshToken     = "refreshToken"
        
        
        static let userUid          = "userUid"                 // == user_id
        static let username         = "username"
        static let displayName      = "displayName"
        
        
        static let isLoggedIn       = "isLoggedIn"
        
        

    }
}
