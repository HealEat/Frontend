




































import Foundation

// ✅ 최상위 음식 종류 카테고리 (대분류)
enum FoodCategory: String, CaseIterable {
    case korean = "한식"
    case japanese = "일식"
    case chinese = "중식"
    case western = "양식"
    case asian = "아시아 음식"
    case snack = "분식"
    case cafeDessert = "카페, 디저트"

    // 🔥 각 카테고리 안에 `FoodSection` 배열을 가짐 (중분류)
    var sections: [String] {
        switch self {
        case .korean:
            return ["죽", "백반", "한정식", "족발, 보쌈", "국밥, 탕", "생선요리"]
        case .japanese:
            return ["샤브샤브", "덮밥", "카레", "오므라이스", "우동, 소바", "초밥, 롤"]
        case .chinese:
            return ["딤섬, 중식만두", "중식당"]
        case .western:
            return ["샌드위치", "이탈리아 음식", "남미음식", "브런치"]
        case .asian:
            return ["베트남 음식", "인도 음식", "태국 음식"]
        case .snack:
            return ["토스트", "김밥", "떡볶이", "종합 분식"]
        case .cafeDessert:
            return ["베이커리", "과일 주스 전문점", "케이크 전문"]
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
            return ["비타민", "저염식", "단백질", "섬유소", "탄수화물"]
        case .foodCharacteristic:
            return ["담백한 음식", "날 음식", "따뜻한 음식", "부드러운 음식", "야채", "국물 요리"]
        }
        
    }
    
    static var allItems: [String] {
        return NutritionCategory.allCases.flatMap { $0.sections }
    }

}
