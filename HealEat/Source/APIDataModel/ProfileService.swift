// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

class ProfileService {
    static let shared = ProfileService()
    private let provider = MoyaProvider<ProfileAPI>()

    func createProfile(name: String, image: Data?, completion: @escaping (Result<Bool, Error>) -> Void) {
        provider.request(.createProfile(name: name, image: image)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(.success(true))
                } else {
                    let error = NSError(domain: "Profile Upload", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "업로드 실패"])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
