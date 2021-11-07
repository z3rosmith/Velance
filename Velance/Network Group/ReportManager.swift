import Foundation
import Alamofire

class ReportManager {
    
    static let shared = ReportManager()
    
    let interceptor = Interceptor()
    
    //MARK: - End Points
    
    let reportAPIBaseUrl            = "\(API.baseUrl)report"
    
    func report(
        type: ReportType,
        model: ReportDTO,
        completion: @escaping ((Result<Bool, NetworkError>) -> Void)
    ) {
        let url: String
        switch type {
        case .feed: url = reportAPIBaseUrl + "/feed"
        case .reply: url = reportAPIBaseUrl + "/reply"
        case .mall: url = reportAPIBaseUrl + "/mall"
        case .product: url = reportAPIBaseUrl + "/product"
        case .review: url = reportAPIBaseUrl + "/review"
        }

        AF.request(
            url,
            method: .post,
            parameters: model.parameters,
            encoding: JSONEncoding.default,
            interceptor: interceptor
        ).responseData { response in
            switch response.result {
            case .success:
                print("✏️ ReportManager - report SUCCESS")
                completion(.success(true))
            case .failure:
                let error = NetworkError.returnError(statusCode: response.response!.statusCode, responseData: response.data ?? Data())
                print("❗️ ReportManager - report error: \(error.errorDescription)")
                completion(.failure(error))
            }
        }
    }
    
    
    func blockUser(
        targetUserId: String,
        completion: @escaping ((Result<Bool, NetworkError>) -> Void)
    ) {
        
        
    }
}
