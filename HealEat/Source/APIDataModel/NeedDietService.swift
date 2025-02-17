







import Moya
import Foundation

class NeedDietService {
    private let provider = MoyaProvider<NeedDietAPI>()

    func sendDietPreference(selectedAnswers: [String], completion: @escaping (Bool) -> Void) {
        provider.request(.sendDietPreference(selectedAnswers: selectedAnswers)) { result in
            switch result {
            case .success(let response):
                print("✅ 식단 선호도 전송 성공:", response.statusCode)
                completion(true)
            case .failure(let error):
                print("❌ 식단 선호도 전송 실패:", error.localizedDescription)
                completion(false)
            }
        }
    }
}
