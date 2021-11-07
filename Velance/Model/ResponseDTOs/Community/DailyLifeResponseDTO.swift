import Foundation

// MARK: - DailyLifeResponseDTO
struct DailyLifeResponseDTO: Decodable {
    let dailyLifeID: Int
    let title, contents: String
    let fileFolder: FileFolder?
    let feed: Feed?
    let isLike: String?

    enum CodingKeys: String, CodingKey {
        case dailyLifeID = "daily_life_id"
        case title, contents, fileFolder, feed
        case isLike = "is_like"
    }
}
