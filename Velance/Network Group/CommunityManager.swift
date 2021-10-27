import Foundation
import Alamofire
import SwiftyJSON

class CommunityManager {
    
    static let shared = CommunityManager()
    
    let interceptor = Interceptor()
    
    //MARK: - End Points
    let newDailyLifePostUrl     = "\(API.baseUrl)daily-life"
    let newRecipePostUrl        = "\(API.baseUrl)recipe"
    
    //MARK: - 일상 글 올리기
    
    func uploadDailyLifePost(
        with model: NewDailyLifeDTO,
        completion: @escaping ((Result<Bool, NetworkError>) -> Void)
    ) {
        showProgressBar()
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(model.createdBy.utf8),withName: "created_by")
            multipartFormData.append(Data(model.title.utf8),withName: "title")
            multipartFormData.append(Data(model.contents.utf8),withName: "contents")
            
            for image in model.files {
                multipartFormData.append(
                    image,
                    withName: "files",
                    fileName: "\(UUID().uuidString).jpeg",
                    mimeType: "image/jpeg"
                )
            }
        },
                  to: newDailyLifePostUrl,
                  method: .post,
                  interceptor: interceptor
        )
            .validate()
            .responseData { response in
                dismissProgressBar()
                switch response.result {
                case .success:
                    print("✏️ CommunityManager - uploadDailyLifePost SUCCESS")
                    completion(.success(true))
                case .failure:
                    let error = NetworkError.returnError(statusCode: response.response?.statusCode ?? 400, responseData: response.data ?? Data())
                    completion(.failure(error))
                    print("❗️ CommunityManager - uploadDailyLifePost error: \(error.errorDescription)")
                }
            }
    }
    
    
    //MARK: - 레시피 글 올리기
    
    func uploadRecipePost(
        with model: NewRecipeDTO,
        completion: @escaping ((Result<Bool, NetworkError>) -> Void)
    ) {
        showProgressBar()
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(model.createdBy.utf8),withName: "created_by")
            multipartFormData.append(Data(model.title.utf8),withName: "title")
            multipartFormData.append(Data(model.contents.utf8),withName: "contents")
            multipartFormData.append(Data(model.recipeCategoryId.description.utf8),withName: "recipe_category_id")
            
            for image in model.files {
                multipartFormData.append(
                    image,
                    withName: "files",
                    fileName: "\(UUID().uuidString).jpeg",
                    mimeType: "image/jpeg"
                )
            }
        },
                  to: newRecipePostUrl,
                  method: .post,
                  interceptor: interceptor
        )
            .validate()
            .responseData { response in
                dismissProgressBar()
                switch response.result {
                case .success:
                    print("✏️ CommunityManager - uploadDailyLifePost SUCCESS")
                    completion(.success(true))
                case .failure:
                    let error = NetworkError.returnError(statusCode: response.response?.statusCode ?? 400, responseData: response.data ?? Data())
                    completion(.failure(error))
                    print("❗️ CommunityManager - uploadDailyLifePost error: \(error.errorDescription)")
                }
            }
    }
}
