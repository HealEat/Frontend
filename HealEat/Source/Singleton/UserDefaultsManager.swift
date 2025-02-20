// Copyright © 2025 HealEat. All rights reserved.

import Foundation

private enum UserDefaultsEnum: String {
    case reviewSort
//    case reviewFilters
}

class UserDefaultsManager {
    
    public static let shared = UserDefaultsManager()
    
    private init() {
        
    }
    
    var reviewSort: SortEnum {
        get {
            return SortEnum(rawValue: UserDefaults.standard.string(forKey: UserDefaultsEnum.reviewSort.rawValue) ?? "") ?? .latest
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: UserDefaultsEnum.reviewSort.rawValue)
        }
    }
    
//    var reviewFilters: Set<FilterEnum> {
//        get {
//            return Set(UserDefaults.standard.stringArray(forKey: UserDefaultsEnum.reviewFilters.rawValue)?.compactMap({
//                FilterEnum(rawValue: $0)
//            }) ?? [.diet, .sick, .veget])
//        }
//        set {
//            UserDefaults.standard.setValue(newValue.map({ $0.rawValue }), forKey: UserDefaultsEnum.reviewFilters.rawValue)
//        }
//    }
}
