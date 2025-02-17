







import Moya
import Foundation

class NeedNutrientService {
    private let provider = MoyaProvider<NeedNutrientAPI>()

    func sendNutrientPreference(selectedAnswers: [String], completion: @escaping (Bool) -> Void) {
        provider.request(.sendNutrientPreference(selectedAnswers: selectedAnswers)) { result in
            switch result {
            case .success(let response):
                print("✅ 영양소 필요 전송 성공:", response.statusCode)
                completion(true)
            case .failure(let error):
                print("❌ 영양소 필요 전송 실패:", error.localizedDescription)
                completion(false)
            }
        }
    }
}
