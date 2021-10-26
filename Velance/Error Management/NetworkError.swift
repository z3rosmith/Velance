import Foundation
import SwiftyJSON

enum NetworkError: Int, Error {
    
    case success        = 200

    // 잘못된 접근 or 요청
    case badRequest     = 400
    case unauthorized   = 401
    case notFound       = 404
    
    // Server 문제
    case internalError  = 500
    
    var errorDescription: String {
        
        switch self {
        
        case .success:
            return "성공"
        case .badRequest:
            return "일시적인 오류입니다. 잠시 후 다시 시도해주세요😢"
        case .internalError:
            return "일시적인 서비스 오류입니다. 잠시 후 다시 시도해주세요😢"
        case .notFound:
            return "요청히신 작업을 처리할 수 없습니다. 잠시 후 다시 시도해주세요😢 "
        case .unauthorized:
            return "로그인이 필요한 기능입니다.🧐"
        }
    }
    
    static func returnError(statusCode: Int, responseData: Data? = nil) -> NetworkError {
        
        print("❗️ Network Error - status code : \(statusCode)")
        if let data = responseData {
            print("❗️ Network Error - error : \(String(data: data, encoding: .utf8) ?? "error encoding error")")
        }
    
        if statusCode == 401 {

//            User.shared.isLoggedIn ?
//                NotificationCenter.default.post(name: .refreshTokenExpired, object: nil) :
//                NotificationCenter.default.post(name: .presentWelcomeVC, object: nil)
        }
        return NetworkError(rawValue: statusCode) ?? .internalError
    }
}
