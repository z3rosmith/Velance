import Foundation
import Alamofire
import SwiftyJSON

class MallManager {
    
    static let shared = MallManager()
    
    let interceptor = Interceptor()
    
    //MARK: - End Points
    let menuUrl      = "\(API.baseUrl)menu"
    let newMallUrl      = "\(API.baseUrl)mall"
    
    //MARK: - 새로운 메뉴 등록
    func uploadNewMenu(
        with model: NewMenuDTO,
        completion: @escaping ((Result<Bool, NetworkError>) -> Void)
    ) {
        showProgressBar()
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(model.createdBy.utf8),withName: "created_by")
            multipartFormData.append(Data(model.mallId.description.utf8),withName: "mall_id")
            multipartFormData.append(Data(model.name.utf8),withName: "name")
            multipartFormData.append(Data(model.price.description.utf8),withName: "price")
            multipartFormData.append(Data(model.caution.utf8),withName: "caution")
            multipartFormData.append(Data(model.isVegan.utf8),withName: "is_vegan")
            
            multipartFormData.append(
                model.files,
                withName: "files",
                fileName: "\(UUID().uuidString).jpeg",
                mimeType: "image/jpeg"
            )
        },
                  to: menuUrl,
                  method: .post,
                  interceptor: interceptor
        )
            .validate()
            .responseData { response in
                dismissProgressBar()
                switch response.result {
                case .success:
                    print("✏️ MallManager - uploadNewMenu SUCCESS")
                    completion(.success(true))
                case .failure:
                    let error = NetworkError.returnError(statusCode: response.response?.statusCode ?? 400, responseData: response.data ?? Data())
                    completion(.failure(error))
                    print("❗️ MallManager - uploadNewMenu error: \(error.errorDescription)")
                }
            }
    }
    
    func uploadNewMall(
        with model: NewMallDTO,
        completion: @escaping ((Result<Bool, NetworkError>) -> Void)
    ) {
        showProgressBar()
        AF.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(Data(model.mallId.description.utf8),withName: "mall_id")
            multipartFormData.append(Data(model.createdBy.utf8),withName: "created_by")
            multipartFormData.append(Data(model.placeName.utf8),withName: "place_name")
            multipartFormData.append(Data(model.phone.utf8),withName: "phone")
            multipartFormData.append(Data(model.addressName.utf8),withName: "address_name")
            multipartFormData.append(Data(model.roadAddressName.utf8),withName: "road_address_name")
            multipartFormData.append(Data(model.x.description.utf8),withName: "x")
            multipartFormData.append(Data(model.y.description.utf8),withName: "y")
            multipartFormData.append(Data(model.onlyVegan.utf8),withName: "only_vegan")
            multipartFormData.append(
                model.file,
                withName: "files",
                fileName: "\(UUID().uuidString).jpeg",
                mimeType: "image/jpeg"
            )
        },
                  to: newMallUrl,
                  method: .post,
                  interceptor: interceptor
        )
            .validate()
            .responseData { response in
                dismissProgressBar()
                switch response.result {
                case .success:
                    print("✏️ MallManager - uploadNewMall SUCCESS")
                    completion(.success(true))
                case .failure:
                    let error = NetworkError.returnError(statusCode: response.response?.statusCode ?? 400, responseData: response.data ?? Data())
                    completion(.failure(error))
                    print("❗️ MallManager - uploadNewMall error: \(error.errorDescription)")
                }
            }
    }
    
    func getMallMenuList(
        page: Int,
        mallId: Int,
        completion: @escaping ((Result<[MallMenuResponseDTO], NetworkError>) -> Void)
    ) {
        
        let parameters: Parameters = [
            "request_user_id": User.shared.userUid,
            "mall_id": mallId,
            "page": page
        ]
        
        AF.request(
            menuUrl,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.queryString,
            interceptor: interceptor
        )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(_):
                    print("✏️ MallManager - getMallMenuList SUCCESS")
                    do {
                        let decodedData = try JSONDecoder().decode([MallMenuResponseDTO].self, from: response.data!)
                        completion(.success(decodedData))
                        
                    } catch {
                        print("❗️ MallManager - getMallMenuList decoding error: \(error)")
                        completion(.failure(.internalError))
                    }
                
                case .failure(_):
                    let error = NetworkError.returnError(statusCode: response.response!.statusCode, responseData: response.data ?? Data())
                    print("❗️ MallManager - getMallMenuList failure with error: \(error.errorDescription)")
                    completion(.failure(error))
                }
            }
        
    }
    
    
}
