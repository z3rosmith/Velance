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
        var url: String
        switch type {
        case .feed: url = reportAPIBaseUrl + "/feed"
        case .reply: url = reportAPIBaseUrl + "/reply"
        case .mall: url = reportAPIBaseUrl + "/mall"
        case .product: url = reportAPIBaseUrl + "/reply"        // 수정 필요
        }
        

        AF.request(
            url,
            method: .post,
            parameters: model.parameters,
            encoding: JSONEncoding.default
        ).responseData { response in
            switch response.result {
            case .success:
                completion(.success(true))
            case .failure:
                let error = NetworkError.returnError(statusCode: response.response!.statusCode, responseData: response.data ?? Data())
                print("❗️ ReportManager - report error: \(error.errorDescription)")
                completion(.failure(error))
            }
        }
    }
}
