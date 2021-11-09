import Foundation

class User {
    
    static var shared: User = User()
    
    private init() {}
    
    var isLoggedIn: Bool {
        get { return UserDefaults.standard.bool(forKey: UserDefaults.Keys.isLoggedIn) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.isLoggedIn) }
    }
    
    var userUid: String {
        get { return UserDefaults.standard.string(forKey: UserDefaults.Keys.userUid) ?? "고유 ID 오류" }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.userUid) }
    }
    
    var username: String {
        get { return UserDefaults.standard.string(forKey: UserDefaults.Keys.username) ?? "username 오류" }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.username) }
    }

    var displayName: String {
        get { return UserDefaults.standard.string(forKey: UserDefaults.Keys.displayName) ?? "닉네임 오류" }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.displayName) }
    }

    var vegetarianType: String {
        get { return UserDefaults.standard.string(forKey: UserDefaults.Keys.vegetarianType) ?? "채식 유형 오류" }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.vegetarianType) }
    }
    
    var accessToken: String {
        get { return UserDefaults.standard.string(forKey: UserDefaults.Keys.accessToken) ?? "토큰 에러" }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.accessToken) }
    }
    
    var refreshToken: String {
        get { return UserDefaults.standard.string(forKey: UserDefaults.Keys.refreshToken) ?? "리프레쉬 토큰 에러" }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.refreshToken) }
    }

    
    var blockedUserList: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: UserDefaults.Keys.blockedUsers) ?? [String]()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.blockedUsers)
        }
    }
}


extension User {
    
    func resetAllUserInfo() {
        
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.isLoggedIn)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.userUid)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.username)

        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.displayName)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.vegetarianType)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.accessToken)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.refreshToken)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.blockedUsers)
       
        
        
    }
}
