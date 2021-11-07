import Foundation
import Alamofire

struct ReportDTO {
    
    var parameters: Parameters = [:]
    
    init(reason: String, mallId: Int) {
        parameters["reason"] = reason
        parameters["mall_id"] = mallId          // 비건 식당 신고할 때 사용
    }
    
    init(reason: String, feedId: Int) {
        parameters["reason"] = reason
        parameters["feed_id"] = feedId          // 커뮤니티 탭에서 어떤 게시글을 신고할 때 사용
    }
    
    init(reason: String, replyId: Int) {
        parameters["reason"] = reason
        parameters["reply_id"] = replyId        // 커뮤니티 탭에서 어떤 댓글을 신고할 때 사용
    }
    
    init(reason: String, reviewId: Int) {
        parameters["reason"] = reason
        parameters["review_id"] = reviewId      // 제품 리뷰 탭에서 특정 리뷰를 신고할 때
    }
    
    init(reason: String, productId: Int) {
        parameters["reason"] = reason
        parameters["product_id"] = productId    // 제품 리뷰 탭에서 제품을 신고할 때
    }
}
