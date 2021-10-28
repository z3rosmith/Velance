import Foundation

// MARK: - Feed
struct Feed: Decodable {
    let feedID: Int
    let createdAt: String
    let user: UserDisplayModel
    let repliesCount, like, dislike: Int

    enum CodingKeys: String, CodingKey {
        case feedID = "feed_id"
        case createdAt = "created_at"
        case user, repliesCount, like, dislike
    }
}
