import Foundation

/// x: longitude, y: latitude
struct MallRequestDTO: Encodable {
    
    let x, y, radius: Double
    let cursor: Int?
    
    init(x: Double, y: Double, radius: Double, cursor: Int? = nil) {
        self.x = x
        self.y = y
        self.radius = radius
        self.cursor = cursor
    }
}
