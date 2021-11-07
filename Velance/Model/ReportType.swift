import Foundation

enum ReportType {
    
    case feed(Feed)
    case reply(Reply)
    case mall(Mall)
    case product(Product)
    case review(Review)
    
    // Feed -> 커뮤니티탭 게시글 신고 사유
    enum Feed: String {
        
        case violentFeed                = "폭력적인 사진/글이 포함되어 있어요."
        case sexualFeed                 = "선정적인 사진/글이 포함되어 있어요."
        case inappropriateFeed          = "그 외 다른 이유로 부적절한 컨텐츠가 있어요."
        
    }
    
    // Reply -> 댓글 신고 사유
    enum Reply: String {
        case violentComment                 = "욕설/비하가 댓글에 포함되어 있어요."
    }
    
    // Mall
    enum Mall: String {
        
        case incorrectMallAddress           = "식당 주소가 잘못되었어요."
        case incorrectMallName              = "식당 이름이 잘못되었어요."
        
    }
    
    // Product
    enum Product: String {
        case incorrectProductPicture        = "제품 사진이 잘못되었어요."
        case inappropriateProductPicture    = "부적절한 제품 사진입니다."
        case incorrectPrice                 = "가격 정보가 잘못되었어요."
    
    }
    
    // Product Review
    enum Review: String {
        case violentReview                 = "폭력적인 사진/글이 포함되어 있어요."
        case sexualReview                  = "선정적인 사진/글이 포함되어 있어요."
        case inappropriateReview           = "그 외 다른 이유로 부적절한 컨텐츠가 있어요."
    }
}
