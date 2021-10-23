import Foundation
import Alamofire
import SwiftyJSON

class UserManager {
    
    static let shared = UserManager()
    
    //MARK: - End Points
    let registerUrl     = "\(API.baseUrl)user/signup"
    
    
    
    func login() {
        
    }
    
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
    
    
    
    
    
    
}
