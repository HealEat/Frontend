// Copyright © 2025 HealEat. All rights reserved.

import Foundation

struct SavedAnswerResponseEntity: Codable {
    let memberId: Int?
    let question: String?
    let savedAnswer: [String]?
}

struct SavedAnswerResponseModel: Codable {
    let memberId: Int
    let question: String
    let savedAnswer: [String]
    
    init(savedAnswerResponseEntity: SavedAnswerResponseEntity) {
        self.memberId = savedAnswerResponseEntity.memberId ?? 0
        self.question = savedAnswerResponseEntity.question ?? ""
        self.savedAnswer = savedAnswerResponseEntity.savedAnswer ?? []
    }
}
