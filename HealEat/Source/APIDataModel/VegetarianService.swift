



































import Foundation
import Moya

class VegetarianService {
    static let shared = VegetarianService()
    private let provider = MoyaProvider<VegetarianAPI>()

    func updateVegetarianType(type: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        provider.request(.updateVegetarian(type: type)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(.success(true))
                } else {
                    let error = NSError(domain: "Vegetarian Update", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "업데이트 실패"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
