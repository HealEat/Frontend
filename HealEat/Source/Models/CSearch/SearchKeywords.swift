// Copyright © 2025 HealEat. All rights reserved.

import Foundation

// ✅ 최상위 음식 종류 카테고리 (대분류)
enum FoodCategory: String, CaseIterable {
    case korean = "한식"
    case chinese = "중식"
    case japanese = "일식"
    case asian = "아시아 음식"
    case western = "양식"
    case familyRestaurant = "패밀리 레스토랑"
    case buffet = "뷔페"
    case lunchbox = "도시락"
    case koreanStreetFood = "분식"
    case snack = "간식"
    case chicken = "치킨"
    case cafe = "카페"
    case fusion = "퓨전요리"
    case shabuShabu = "샤브샤브"
    case fastFood = "패스트푸드"
    case salad = "샐러드"

    // 🔥 각 카테고리 안에 `FoodSection` 배열을 가짐 (중분류)
    var sections: [String] {
        switch self {
        case .korean:
            return ["국수", "육류, 고기", "국밥", "해장국", "해물, 생선", "수제비", "두부 전문점", "순대", "설렁탕", "한정식", "쌈밥", "죽", "냉면", "찌개, 전골", "감자탕", "곰탕", "사찰음식", "주먹밥"]
        case .chinese:
            return ["중국요리", "양꼬치"]
        case .japanese:
            return ["돈까스, 우동", "일본식라면", "참치회", "초밥, 롤"]
        case .asian:
            return ["인도 음식", "동남아 음식", "튀르키예 음식"]
        case .western:
            return ["햄버거", "피자", "스테이크, 립", "이탈리안", "멕시칸, 브라질", "해산물", "프랑스 음식", "스페인 음식"]
        case .familyRestaurant:
            return ["아웃백스테이크하우스 딜리버리", "아웃백스테이크하우스", "애슐리", "빕스"]
        case .buffet:
            return ["해산물 뷔페", "한식 뷔페", "고기 뷔페"]
        case .lunchbox:
            return  ["배달 도시락", "한솥 도시락"]
        case .koreanStreetFood:
            return ["떡볶이"]
        case .snack:
            return ["제과, 베이커리", "도넛", "닭강정", "떡, 한과", "토스트", "아이스크림"]
        case .chicken:
            return ["치킨"]
        case .cafe:
            return ["커피 전문점"]
        case .fusion:
            return ["퓨전 한식", "퓨전 일식", "퓨전 중식"]
        case .shabuShabu:
            return ["샤브샤브"]
        case .fastFood:
            return ["서브웨이", "쉐이크쉑", "맥도날드", "버거킹", "롯데리아", "맘스터치"]
        case .salad:
            return ["샐러드"]
        }
    }
    
    static var allItems: [String] {
        return FoodCategory.allCases.flatMap { $0.sections }
    }

}



// ✅ 최상위 음식 특징 카테고리 (대분류)
enum NutritionCategory: String, CaseIterable {
    case nutrition = "영양 성분"
    case foodCharacteristic = "음식 특징"
    
    // 🔥 각 카테고리 안에 `FoodSection` 배열을 가짐 (중분류)
    var sections: [String] {
        switch self {
        case .nutrition:
            return ["단백질", "비타민", "지방", "탄수화물", "무기질", "섬유소"]
        case .foodCharacteristic:
            return ["담백한 음식", "면요리", "부드러운 음식", "소화가 잘 되는 음식", "날 음식", "따뜻한 음식", "짜지 않은 음식", "국물 요리", "야채"]
        }
        
    }
    
    static var allItems: [String] {
        return NutritionCategory.allCases.flatMap { $0.sections }
    }

}
