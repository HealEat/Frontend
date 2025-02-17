










import Moya
import Foundation

class DiseaseQuestionService {
    private let provider = MoyaProvider<DiseaseQuestionAPI>()

    // ✅ Step 2에서 선택된 옵션을 서버로 전송하는 POST 요청
    func sendSelectedOptions(selectedOptions: [String], completion: @escaping (Bool) -> Void) {
        provider.request(.sendOptions(selectedAnswers: selectedOptions)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    let isSuccess = json?["isSuccess"] as? Bool ?? false
                    completion(isSuccess)
                } catch {
                    print("❌ JSON Parsing Error: \(error)")
                    completion(false)
                }
            case .failure(let error):
                print("❌ POST Request Error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
