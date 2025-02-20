// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct SearchResponseEntity: Codable {
    let id: Int?
    let name: String?
}

struct SearchResponseModel: Codable {
    let id: Int
    let name: String
    
    init(searchResponseEntity: SearchResponseEntity) {
        self.id = searchResponseEntity.id ?? 0
        self.name = searchResponseEntity.name ?? ""
    }
}
