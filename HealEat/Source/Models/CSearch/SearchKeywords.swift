// Copyright © 2025 HealEat. All rights reserved.

import Foundation

import Foundation

// ✅ 대분류 (최상위 카테고리)
enum FoodCategory: String, CaseIterable {
    case korean = "한식"
    case chinese = "중식"
    case japanese = "일식"
    case asian = "아시아음식"
    case western = "양식"
    case fusion = "퓨전요리"
    case fastFood = "패스트푸드"
    case shabuShabu = "샤브샤브"
    case salad = "샐러드"
    case streetFood = "분식"

    // ✅ 각 대분류가 가지고 있는 중분류 리스트 (ID 추가됨)
    var sections: [(id: Int, name: String)] {
        switch self {
        case .korean:
            return [
                (1, "육류, 고기"), (2, "갈비"), (3, "닭요리"), (4, "오리"),
                (5, "족발, 보쌈"), (6, "불고기, 두루치기"), (7, "해물, 생선"),
                (8, "회"), (9, "조개"), (10, "굴, 전복"), (11, "복어"),
                (12, "아구"), (13, "추어"), (14, "매운탕, 해물탕"),
                (15, "두부 전문점"), (16, "한정식"), (17, "죽"), (18, "찌개, 전골"),
                (19, "감자탕"), (20, "국밥"), (21, "해장국"), (22, "설렁탕"),
                (23, "곰탕"), (24, "국수"), (25, "냉면"), (26, "수제비"),
                (27, "순대"), (28, "쌈밥")
            ]
        case .chinese:
            return [(29, "중국요리")]
        case .japanese:
            return [(30, "일식"), (31, "초밥, 롤"), (32, "돈까스, 우동"), (33, "일본식라면"), (34, "참치회")]
        case .asian:
            return [(35, "인도음식"), (36, "베트남음식"), (37, "동남아음식")]
        case .western:
            return [(38, "스테이크, 립"), (39, "이탈리안"), (40, "멕시칸, 브라질")]
        case .fusion:
            return [(41, "퓨전요리"), (42, "퓨전한식"), (43, "퓨전일식"), (44, "퓨전중식")]
        case .fastFood:
            return [(45, "샌드위치")]
        case .shabuShabu:
            return [(46, "샤브샤브")]
        case .salad:
            return [(47, "샐러드")]
        case .streetFood:
            return [(48, "분식")]
        }
    }
    
    // ✅ 모든 카테고리의 리스트 (이전 allItems 역할)
    static var allItems: [(id: Int, name: String)] {
        return FoodCategory.allCases.flatMap { $0.sections }
    }
}
//사용예시
//let categoryNames = FoodCategory.allItems.map { $0.name }



// ✅ 대분류 (영양 성분 & 음식 특징)
enum NutritionCategory: String, CaseIterable {
    case nutrition = "영양 성분"
    case foodCharacteristic = "음식 특징"

    // ✅ 각 대분류가 가지고 있는 중분류 리스트 (ID 추가됨)
    var sections: [(id: Int, name: String)] {
        switch self {
        case .nutrition:
            return [
                (1, "단백질"), (2, "비타민"), (3, "지방"), (4, "탄수화물"),
                (5, "무기질"), (6, "섬유소")
            ]
        case .foodCharacteristic:
            return [
                (7, "담백한 음식"), (8, "면요리"), (9, "부드러운 음식"),
                (10, "소화가 잘 되는 음식"), (11, "날 음식"), (12, "따뜻한 음식"),
                (13, "짜지 않은 음식"), (14, "국물 요리"), (15, "야채")
            ]
        }
    }

    // ✅ 모든 카테고리를 하나의 배열로 가져오기 (ID 포함)
    static var allItems: [(id: Int, name: String)] {
        return NutritionCategory.allCases.flatMap { $0.sections }
    }
}

// ✅ 사용 예시
//let allNutritionFeatures = NutritionCategory.allItems
//print(allNutritionFeatures)
/*
 [
    (1, "단백질"), (2, "비타민"), (3, "지방"), (4, "탄수화물"),
    (5, "무기질"), (6, "섬유소"), (7, "담백한 음식"), (8, "면요리"),
    (9, "부드러운 음식"), (10, "소화가 잘 되는 음식"), (11, "날 음식"),
    (12, "따뜻한 음식"), (13, "짜지 않은 음식"), (14, "국물 요리"), (15, "야채")
 ]
*/
