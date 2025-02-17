// Copyright © 2025 HealEat. All rights reserved.

import Foundation


struct HealthGoalRequest: Codable {
    let duration: String
    let number: Int
    let goal: String
    let imageIds: [Int]
}


struct UploadHGImages: Codable {
    let imageType: String
    let imageExtension: String

    enum CodingKeys: String, CodingKey {
        case imageType = "image-type"   // JSON의 `image-type`을 Swift의 `imageType`으로 매핑
        case imageExtension = "imageExtenstion" // JSON의 `imageExtension`을 Swift의 `imageExtension`으로 매핑
    }
}
