// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct InfoLoadResponseEntity: Codable {
    let memberId: Int?
    let healEatFoods: [String]?
}

struct InfoLoadResponseModel: Codable {
    let memberId: Int
    let healEatFoods: [String]
    
    init(infoLoadResponseEntity: InfoLoadResponseEntity) {
        self.memberId = infoLoadResponseEntity.memberId ?? 0
        self.healEatFoods = infoLoadResponseEntity.healEatFoods ?? []
    }
}
