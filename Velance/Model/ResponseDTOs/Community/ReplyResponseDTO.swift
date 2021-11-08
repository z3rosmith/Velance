import Foundation

// MARK: - ReplyResponseDTO
struct ReplyResponseDTO: Decodable {
    let replyID: Int
    let contents, createdAt: String
    let user: UserDisplayModel

    enum CodingKeys: String, CodingKey {
        case replyID = "reply_id"
        case contents
        case createdAt = "created_at"
        case user
    }
}
