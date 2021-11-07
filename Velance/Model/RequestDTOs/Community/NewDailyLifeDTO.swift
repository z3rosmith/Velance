import Foundation

struct NewDailyLifeDTO: Encodable {
    
    let title: String
    let contents: String
    let region_ids: [String]
    let files: [Data]
    
    init(title: String, contents: String, regionIds: [String], files: [Data]) {
        self.title = title
        self.contents = contents
        self.region_ids = regionIds
        self.files = files
    }
}
