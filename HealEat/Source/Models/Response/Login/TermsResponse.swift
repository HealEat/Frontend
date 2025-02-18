// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct TermsResponse: Codable {
    let id: Int
    let title: String
    let body: String
    let isRequired: Bool
}
