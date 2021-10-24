import Foundation

struct FileFolder: Codable {
    let fileFolderID, createdAt, type: String
    let files: [File]
    
    enum CodingKeys: String, CodingKey {
        case fileFolderID = "file_folder_id"
        case createdAt = "created_at"
        case type, files
    }
}

