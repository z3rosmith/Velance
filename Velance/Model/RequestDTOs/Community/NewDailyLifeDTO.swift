import Foundation

struct NewDailyLifeDTO: Encodable {
    
    let title: String
    let contents: String
    let files: [Data]
    
    init(title: String, contents: String, files: [Data]) {
        self.title = title
        self.contents = contents
        self.files = files
    }
}
