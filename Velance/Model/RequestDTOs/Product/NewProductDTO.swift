import Foundation

struct NewProductDTO: Encodable {
    
    let productCategoryId: Int
    let PRDLST_REPORT_NO: String
    let name: String
    let RAWMTRL_NM: [String]
    let price: Int
    let file: Data
    
    init(productCategoryId: Int, name: String, price: Int, file: Data, productReportNumber: String, productRawMaterialNames: String) {
        self.productCategoryId = productCategoryId
        self.name = name
        self.price = price
        self.file = file
        
        self.PRDLST_REPORT_NO = productReportNumber
        
        let separatedRawMaterialNames: [String] = productRawMaterialNames.components(separatedBy: ",")
        self.RAWMTRL_NM = separatedRawMaterialNames
        
        print("✏️ RAW MATERIAL: \(RAWMTRL_NM)")
        print("✏️ ProductListReporTNO: \(PRDLST_REPORT_NO)")
        
        
    }
}
