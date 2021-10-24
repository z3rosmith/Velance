import Foundation

struct LoginResponseDTO: Decodable {
    
    let accessToken: String
    let userUid: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case userUid = "user_id"
    }
}
