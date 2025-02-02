// Copyright © 2025 HealEat. All rights reserved.

import Foundation

class QuestionFlowManager {
    private var askedQuestions: [String] = []

    private let questions = ["NeedDiet", "NeedNutrient", "NeedToAvoid"]

    // 다음 질문 반환
    func getNextQuestion() -> String? {
        for question in questions {
            if !askedQuestions.contains(question) {
                askedQuestions.append(question)
                return question
            }
        }
        return nil // 질문이 더 이상 없을 때
    }

    // 현재 질문 완료 상태 체크
    func isQuestionAsked(_ question: String) -> Bool {
        return askedQuestions.contains(question)
    }
}
