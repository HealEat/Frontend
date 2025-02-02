// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct SaveStoreRequest: Codable {
    let placeId: String
    let placeName: String
    let categoryName: String
    let phone: String
    let addressName: String
    let roadAddressName: String
    let x: String
    let y: String
    let placeUrl: String
    let daumImgUrlList: [String]
}
