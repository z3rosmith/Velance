import Foundation

struct UserOptions {
    
    static let veganType: [String] = ["비건", "오보", "락토", "락토/오보", "페스코"]
    
    static let tasteOption: [String] = ["짭짤한", "매콤한", "달달한",
                                        "단짠단짠", "깔끔한", "싱겁게",
                                        "새콤달콤", "크리미한", "시큼한",
                                        "밥류", "탕류", "조림류",
                                        "면류", "구이류", "볶음류", "튀김류"]
    
    static let interestOptions: [String] = ["동물", "환경", "정신건강",
                                            "운동", "독서", "인권",
                                            "경제", "패션", "사진",
                                            "일상", "퀴어", "그림",
                                            "여행", "IT", "엔터테인먼트"]
    
    static let allergyOptions: [String] = ["우유", "난류(알)", "밀가루",
                                           "새우", "메밀", "콩류", "조개류",
                                           "견과류", "갑각류", "아황산류", "키위", "토마토", "복숭아"]
}
