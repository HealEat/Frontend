







import Moya
import Foundation

class NeedToAvoidService {
    private let provider = MoyaProvider<NeedToAvoidAPI>()

    func sendAvoidPreference(selectedAnswers: [String], completion: @escaping (Bool) -> Void) {
        provider.request(.sendAvoidancePreference(selectedAnswers: selectedAnswers)) { result in
            switch result {
            case .success(let response):
                print("✅ 피해야 할 음식 전송 성공:", response.statusCode)
                completion(true)
            case .failure(let error):
                print("❌ 피해야 할 음식 전송 실패:", error.localizedDescription)
                completion(false)
            }
        }
    }
}
