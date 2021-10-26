import Foundation

struct File: Codable {
    let fileID: String
    let path: String
    let originalName, fileExtension, size, createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case fileID = "file_id"
        case path
        case originalName = "original_name"
        case fileExtension = "extension"
        case size
        case createdAt = "created_at"
    }
}
