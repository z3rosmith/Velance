import Foundation
import Alamofire
import SwiftyJSON

class UserManager {
    
    static let shared = UserManager()
    
    //MARK: - End Points
    let registerUrl     = "\(API.baseUrl)user/signup"
    let loginUrl        = "\(API.baseUrl)auth/login"

    
    func register(
        with model: UserRegisterDTO,
        completion: @escaping ((Result<Bool, NetworkError>) -> Void)
    ) {
        
        AF.request(
            registerUrl,
            method: .post,
            parameters: model.parameters,
            encoding: JSONEncoding.default
        ).responseJSON { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch statusCode {
            case 201:
                do {
                    let json = try JSON(data: response.data ?? Data())
                    
                    completion(.success(true))
                } catch {
                    completion(.failure(.internalError))
                }
            default:
                let error = NetworkError.returnError(statusCode: statusCode, responseData: response.data ?? Data())
                print("❗️ \(error.errorDescription)")
                completion(.failure(error))
            }
        }
        
    }
    
    
    func login(
        username: String,
        password: String,
        completion: @escaping ((Result<Bool, NetworkError>) -> Void)
    ) {
        
        let parameters = ["user_name": username, "password": password]
        
        AF.request(
            loginUrl,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default
        ).responseJSON { response in
            guard let statusCode = response.response?.statusCode else { return }
            switch statusCode {
            case 200..<300:
                do {
                    let json = try JSON(data: response.data ?? Data())
                    User.shared.accessToken = json["access_token"].stringValue
                    User.shared.userUid = json["user_id"].stringValue
                    User.shared.isLoggedIn = true
                } catch {
                    completion(.failure(.internalError))
                }
                completion(.success(true))
            default:
                let error = NetworkError.returnError(statusCode: statusCode, responseData: response.data ?? Data())
                print("❗️ Login Error: \(error.errorDescription)")
                completion(.failure(error))
            }
            
        }
    }
    
    
    
    
    
    
    
    
}
