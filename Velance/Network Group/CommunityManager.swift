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
    let fetchUserFeedListUrl    = "\(API.baseUrl)feed/user"
    let feedBaseUrl             = "\(API.baseUrl)feed/"
    let fetchRepliesURL         = "\(API.baseUrl)reply"
    let postReplyURL            = "\(API.baseUrl)reply"
    let followUserURL           = "\(API.baseUrl)follow"
    let likeFeedURL             = "\(API.baseUrl)feed/like"
    
    //MARK: - 일상 글 올리기
    
    func uploadDailyLifePost(
        with model: NewDailyLifeDTO,
        completion: @escaping ((Result<Bool, NetworkError>) -> Void)
    ) {
        showProgressBar()
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(model.title.utf8),withName: "title")
            multipartFormData.append(Data(model.contents.utf8),withName: "contents")
            
            for regionIds in model.region_ids {
                multipartFormData.append(Data(regionIds.utf8), withName: "region_ids")
            }
            
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
        parameters["cursor"] = model.cursor
        parameters["only_following"] = model.onlyFollowing
        
        var array: [Int] = []
        if let interestTypeIDs = model.interestTypeIDs, interestTypeIDs.count > 0 {
            interestTypeIDs.forEach { array.append($0) }
            parameters["interest_type_ids"] = array
        }
        
        var array2: [String] = []
        if let regionIds = model.regionsIds, regionIds.count > 0 {
            regionIds.forEach { array2.append($0) }
            parameters["region_ids"] = array2
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
                        print("✏️ COMMUNITY MANAGER - fetchDailyLifeList - fetch SUCCESS")
                    } catch {
                        print("❗️ COMMUNITY MANAGER - fetchDailyLifeList - FAILED PROCESS DATA with error: \(error)")
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
    
    // MARK: - 피드 목록 받아오기
    func fetchUserFeedList(userID: String,
                           cursor: Int?,
                           completion: @escaping ((Result<[UserFeedResponseDTO], NetworkError>) -> Void)) {
        
        var parameters: Parameters = [:]
        parameters["cursor"] = cursor
        parameters["user_id"] = userID

        AF.request(fetchUserFeedListUrl,
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
                        let decodedData = try JSONDecoder().decode([UserFeedResponseDTO].self, from: dataJSON)
                        completion(.success(decodedData))
                        print("✏️ \(String(describing: type(of: self))) - \(#function) - fetch SUCCESS")
                    } catch {
                        print("✏️ \(String(describing: type(of: self))) - \(#function) - FAILED PROCESS DATA with error: \(error)")
                    }
                case .failure(let error):
                    if let jsonData = response.data {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with server error:\(String(data: jsonData, encoding: .utf8) ?? "")")
                    }
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    func fetchPostDetail(isRecipe: Bool,
                         id: Int,
                         completion: @escaping ((Result<FeedDetailResponseDTO, NetworkError>) -> Void)) {
        
        var url = isRecipe ? fetchRecipeListUrl : fetchDailyLifeListUrl
        url += "/\(id)"
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   interceptor: interceptor)
            .validate()
            .responseJSON { response in

                switch response.result {
                case .success(let value):
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let decodedData = try JSONDecoder().decode(FeedDetailResponseDTO.self, from: dataJSON)
                        completion(.success(decodedData))
                        print("✏️ \(String(describing: type(of: self))) - \(#function) - fetch SUCCESS")
                    } catch {
                        print("✏️ \(String(describing: type(of: self))) - \(#function) - FAILED PROCESS DATA with error: \(error)")
                    }
                case .failure(let error):
                    if let jsonData = response.data {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with server error:\(String(data: jsonData, encoding: .utf8) ?? "")")
                    }
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    func fetchReplies(feedID: Int,
                      cursor: Int?,
                      completion: @escaping ((Result<[ReplyResponseDTO], NetworkError>) -> Void)) {
        
        var parameters: Parameters = [:]
        parameters["feed_id"] = feedID
        parameters["cursor"] = cursor
        
        AF.request(fetchRepliesURL,
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
                        let decodedData = try JSONDecoder().decode([ReplyResponseDTO].self, from: dataJSON)
                        completion(.success(decodedData))
                        print("✏️ \(String(describing: type(of: self))) - \(#function) - fetch SUCCESS")
                    } catch {
                        print("✏️ \(String(describing: type(of: self))) - \(#function) - FAILED PROCESS DATA with error: \(error)")
                    }
                case .failure(let error):
                    if let jsonData = response.data {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with server error:\(String(data: jsonData, encoding: .utf8) ?? "")")
                    }
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    func postReply(feedID: Int,
                   contents: String,
                   completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        let url = postReplyURL + "/\(feedID)"
        let parameters: Parameters = ["contents": contents]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   interceptor: interceptor)
            .validate()
            .responseJSON { response in

                switch response.result {
                case .success:
                    completion(.success(true))
                    print("✏️ \(String(describing: type(of: self))) - \(#function) - post SUCCESS")
                case .failure(let error):
                    if let jsonData = response.data {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with server error:\(String(data: jsonData, encoding: .utf8) ?? "")")
                    }
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    func folllowUser(targetUID: String,
                     completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        let parameters: Parameters = ["target_id": targetUID]
        
        AF.request(followUserURL,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   interceptor: interceptor)
            .validate()
            .responseJSON { response in

                switch response.result {
                case .success:
                    completion(.success(true))
                    print("✏️ \(String(describing: type(of: self))) - \(#function) - post SUCCESS")
                case .failure(let error):
                    if let jsonData = response.data {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with server error:\(String(data: jsonData, encoding: .utf8) ?? "")")
                    }
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    func unfollowUser(targetUID: String,
                      completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        let url = followUserURL + "/\(targetUID)"
        
        AF.request(url,
                   method: .delete,
                   interceptor: interceptor)
            .validate()
            .responseJSON { response in

                switch response.result {
                case .success:
                    completion(.success(true))
                    print("✏️ \(String(describing: type(of: self))) - \(#function) - delete SUCCESS")
                case .failure(let error):
                    if let jsonData = response.data {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with server error:\(String(data: jsonData, encoding: .utf8) ?? "")")
                    }
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    func likeFeed(feedID: Int,
                  completion: @escaping ((Result<Bool, NetworkError>) -> Void)) {
        
        let url = likeFeedURL + "/\(feedID)"
        let parameters: Parameters = ["is_like": "Y"]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   interceptor: interceptor)
            .validate()
            .responseJSON { response in

                switch response.result {
                case .success:
                    completion(.success(true))
                    print("✏️ \(String(describing: type(of: self))) - \(#function) - post SUCCESS")
                case .failure(let error):
                    if let jsonData = response.data {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with server error:\(String(data: jsonData, encoding: .utf8) ?? "")")
                    }
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
    
    func unlikeFeed(
        feedID: Int,
        completion: @escaping ((Result<Bool, NetworkError>) -> Void)
    ) {
        
        let url = likeFeedURL + "/\(feedID)"
        
        AF.request(url,
                   method: .delete,
                   interceptor: interceptor)
            .validate()
            .responseJSON { response in

                switch response.result {
                case .success:
                    completion(.success(true))
                    print("✏️ \(String(describing: type(of: self))) - \(#function) - delete SUCCESS")
                case .failure(let error):
                    if let jsonData = response.data {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with server error:\(String(data: jsonData, encoding: .utf8) ?? "")")
                    }
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with alamofire error: \(error.localizedDescription)")
                    guard let responseCode = error.responseCode else {
                        print("❗️ \(String(describing: type(of: self))) - \(#function) - Empty responseCode")
                        return
                    }
                    let customError = NetworkError.returnError(statusCode: responseCode)
                    print("❗️ \(String(describing: type(of: self))) - \(#function) - FAILED REQEUST with custom error: \(customError.errorDescription)")
                    completion(.failure(customError))
                }
            }
    }
}

extension CommunityManager {
    
    func deleteMyFeed(
        feedId: Int,
        completion: @escaping ((Result<Bool, NetworkError>) -> Void)
    ) {
        
        let url = feedBaseUrl + String(feedId)
        
        AF.request(
            url,
            method: .delete,
            interceptor: interceptor
        )
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("✏️ CommunityManager - deleteMyFeed SUCCESS")
                    completion(.success(true))
                case .failure:
                    print("❗️ CommunityManager - deleteMyFeed ERROR")
                    let error = NetworkError.returnError(statusCode: response.response?.statusCode ?? 400, responseData: response.data ?? Data())
                    completion(.failure(error))
                }
            }
    }
    
    func deleteMyReply(
        replyId: Int,
        completion: @escaping ((Result<Bool, NetworkError>) -> Void)
    ) {
        
        let url = fetchRepliesURL + "/\(replyId)"
        
        AF.request(
            url,
            method: .delete,
            interceptor: interceptor
        )
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    print("✏️ CommunityManager - deleteMyReply SUCCESS")
                    completion(.success(true))
                case .failure:
                    print("❗️ CommunityManager - deleteMyReply ERROR")
                    let error = NetworkError.returnError(statusCode: response.response?.statusCode ?? 400, responseData: response.data ?? Data())
                    completion(.failure(error))
                }
            }
        
    }
}
