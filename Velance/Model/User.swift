import Foundation

class User {
    
    static var shared: User = User()
    
    private init() {}
    
    var userUid: String {
        get { return UserDefaults.standard.string(forKey: UserDefaults.Keys.userUid) ?? "아이디 오류" }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.userUid) }
    }


    
    var accessToken: String {
        get { return UserDefaults.standard.string(forKey: UserDefaults.Keys.accessToken) ?? "토큰 에러" }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.accessToken) }
    }
    
    var refreshToken: String {
        get { return UserDefaults.standard.string(forKey: UserDefaults.Keys.refreshToken) ?? "토큰 에러" }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.refreshToken) }
    }

    
    
}
