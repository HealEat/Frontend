// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct TermsResponse: Codable {
    let id: Int
    let title: String
    let body: String
    let isRequired: Bool
}

struct TermsRequest: Codable {
    let agreements: [Term]
}

struct Term: Codable {
    let termId: Int
    let agree: Bool
}

struct TermStatusResponse: Codable {
    let termId: Int
    let title: String
    let agree: Bool
}
