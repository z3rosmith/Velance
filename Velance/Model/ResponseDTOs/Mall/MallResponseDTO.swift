import Foundation

struct MallResponseDTO: Decodable {
    
    let mallID: Int
    let placeName: String
    let phone, addressName, roadAddressName: String?
    let x, y: Double
    let onlyVegan, createdAt: String
    let fileFolder: FileFolder?
    let distance, vegunMenuCount: Int

    enum CodingKeys: String, CodingKey {
        case mallID = "mall_id"
        case placeName = "place_name"
        case phone
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case x, y
        case onlyVegan = "only_vegan"
        case createdAt = "created_at"
        case fileFolder, distance, vegunMenuCount
    }
}
