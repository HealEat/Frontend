



import Foundation
import Moya

class GetNameService {
    static let shared = GetNameService()  // 싱글톤 인스턴스 생성
    private let provider = MoyaProvider<GetNameAPI>()

    func fetchUserName(completion: @escaping (String) -> Void) {
        provider.request(.fetchUserName) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    if let result = json?["result"] as? [String: Any],
                       let name = result["name"] as? String {
                        DispatchQueue.main.async {
                            completion(name)
                        }
                    }
                } catch {
                    print("❌ JSON 파싱 오류: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion("알 수 없음")  // 실패 시 기본값
                    }
                }
            case .failure(let error):
                print("❌ 네트워크 요청 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion("알 수 없음")  // 실패 시 기본값
                }
            }
        }
    }
}
