// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import UIKit

struct ReviewWriteRequest {
    struct Request: Codable {
        let healthScore: Float
        let tastyScore: Float
        let cleanScore: Float
        let freshScore: Float
        let nutrScore: Float
        let body: String
    }
    let placeId: Int
    let images: [Data]
    let request: Request
}

