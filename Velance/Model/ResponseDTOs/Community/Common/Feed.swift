import Foundation

// MARK: - Feed
struct Feed: Decodable {
    let feedID: Int
    let createdAt: String
    let user: UserDisplayModel

    enum CodingKeys: String, CodingKey {
        case feedID = "feed_id"
        case createdAt = "created_at"
        case user
    }
}
