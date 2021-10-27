import Foundation

struct NewDailyLifeDTO: Encodable {
    
    let createdBy: String
    let title: String
    let contents: String
    let files: [Data]
    
    init(title: String, contents: String, files: [Data]) {
        self.createdBy = User.shared.userUid
        self.title = title
        self.contents = contents
        self.files = files
    }
}
