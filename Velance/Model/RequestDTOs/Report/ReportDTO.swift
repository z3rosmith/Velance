import Foundation
import Alamofire

struct ReportDTO {
    
    var parameters: Parameters = [:]
    
    init(createdBy: String, reason: String, mallId: Int) {
        parameters["created_by"] = createdBy
        parameters["reason"] = reason
        parameters["mall_id"] = mallId  // 비건 식당 신고할 때 사용
    }
    
    init(createdBy: String, reason: String, feedId: Int) {
        parameters["created_by"] = createdBy
        parameters["reason"] = reason
        parameters["feed_id"] = feedId      // 커뮤니티 탭에서 어떤 게시글을 신고할 때 사용
    }
    
    init(createdBy: String, reason: String, replyId: Int) {
        parameters["created_by"] = createdBy
        parameters["reason"] = reason
        parameters["reply_id"] = replyId  // 커뮤니티 탭에서 어떤 댓글을 신고할 때 사용
    }
}
