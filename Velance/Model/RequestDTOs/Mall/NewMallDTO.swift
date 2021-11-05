import Foundation

struct NewMallDTO: Encodable {
    
    let mallId: Int         //카카오 mall id
    let placeName: String
    let phone: String
    let addressName: String
    let roadAddressName: String
    let x: Double
    let y: Double
    let onlyVegan: String
    let file: Data
    
    init(mallId: Int, placeName: String, phone: String, addressName: String, roadAddressName: String, x: Double, y: Double, onlyVegan: String, file: Data) {
        
        self.mallId = mallId
        self.placeName = placeName
        self.phone = phone
        self.addressName = addressName
        self.roadAddressName = roadAddressName
        self.x = x
        self.y = y
        self.onlyVegan = onlyVegan
        self.file = file
    }
}
