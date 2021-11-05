import Foundation

struct NewMenuDTO: Encodable {
    
    let mallId: Int
    let name: String
    let price: Int
    let caution: String
    let files: Data
    let isVegan: String         // "Y" or "N"
    #warning("isVegan 부분 수정 필요 -> 과연 필요한가?")
    
    init(mallId: Int, name: String, price: Int, caution: String, file: Data, isVegan: String) {
        self.mallId = mallId
        self.name = name
        self.price = price
        self.caution = caution
        self.files = file
        self.isVegan = isVegan
    }
    
}
