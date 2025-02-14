




import Moya
import Foundation

class DietService {
    static let shared = DietService()
    private let provider = MoyaProvider<DietAPI>()

    func updateDietType(type: String, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.updateDietType(type: type)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(.success(()))
                } else {
                    let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "서버 오류"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
