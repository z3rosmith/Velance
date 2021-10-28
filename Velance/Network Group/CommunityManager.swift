import Foundation
import Alamofire
import SwiftyJSON

class CommunityManager {
    
    static let shared = CommunityManager()
    
    let interceptor = Interceptor()
    
    //MARK: - End Points
    let newDailyLifePostUrl     = "\(API.baseUrl)daily-life"
    let newRecipePostUrl        = "\(API.baseUrl)recipe"
    let fetchRecipeListUrl      = "\(API.baseUrl)recipe"
    let fetchDailyLifeListUrl   = "\(API.baseUrl)daily-life"
    
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
    
    // MARK: - 레시피 목록 받아오기
    func fetchRecipeList(with model: RecipeRequestDTO,
                         completion: @escaping ((Result<[RecipeResponseDTO], NetworkError>) -> Void)) {
        
        var parameters: Parameters = [:]
        parameters["request_user_id"] = model.requestUserID
        parameters["cursor"] = model.cursor
        parameters["recipe_category_id"] = model.recipeCategoryID
        parameters["only_following"] = model.onlyFollowing
        
        AF.request(fetchRecipeListUrl,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.queryString,
                   interceptor: interceptor)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decodedData = try JSONDecoder().decode([RecipeResponseDTO].self, from: dataJSON)
                        completion(.success(decodedData))
                        print("✏️ COMMUNITY MANAGER - fetchRecipeList - fetch SUCCESS")
                    } catch {
                        print("❗️ COMMUNITY MANAGER - fetchRecipeList - FAILED PROCESS DATA with error: \(error)")
                    }
                case .failure(let error):
                    if let jsonData = response.data {
                        print("❗️ COMMUNITY MANAGER - fetchRecipeList - FAILED REQEUST with server error:\(String(data: jsonData, encoding: .utf8) ?? "")")
                    }
                    print("❗️ COMMUNITY MANAGER - fetchRecipeList - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("❗️ COMMUNITY MANAGER - fetchRecipeList - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("❗️ COMMUNITY MANAGER - fetchRecipeList - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    // MARK: - 일상 목록 받아오기
    func fetchDailyLifeList(with model: DailyLifeRequestDTO,
                         completion: @escaping ((Result<[DailyLifeResponseDTO], NetworkError>) -> Void)) {

        var parameters: Parameters = [:]
        parameters["request_user_id"] = model.requestUserID
        parameters["cursor"] = model.cursor
        parameters["only_following"] = model.onlyFollowing
        
        var array: [Int] = []
        if let interestTypeIDs = model.interestTypeIDs, interestTypeIDs.count > 0 {
            interestTypeIDs.forEach { array.append($0) }
            #warning("parameter array 보내는거 구현")
//            parameters["interest_type_ids"] = array
        }

        AF.request(fetchDailyLifeListUrl,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.queryString,
                   interceptor: interceptor)
            .validate()
            .responseJSON { response in

                switch response.result {
                case .success(let value):
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decodedData = try JSONDecoder().decode([DailyLifeResponseDTO].self, from: dataJSON)
                        completion(.success(decodedData))
                    } catch {
                        print("✏️ COMMUNITY MANAGER - fetchDailyLifeList - FAILED PROCESS DATA with error: \(error)")
                    }
                case .failure(let error):
                    if let jsonData = response.data {
                        print("❗️ COMMUNITY MANAGER - fetchDailyLifeList - FAILED REQEUST with server error:\(String(data: jsonData, encoding: .utf8) ?? "")")
                    }
                    print("❗️ COMMUNITY MANAGER - fetchDailyLifeList - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("❗️ COMMUNITY MANAGER - fetchDailyLifeList - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("❗️ COMMUNITY MANAGER - fetchDailyLifeList - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
}
