// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya

class ProfileService {
    static let shared = ProfileService()

    func createProfile(name: String, image: Data?, completion: @escaping (Result<Bool, Error>) -> Void) {
        APIManager.ProfileProvider.request(.createProfile(name: name, image: image)) { result in
            switch result {
            case .success(let response):
                print("📩 서버 응답 상태 코드: \(response.statusCode)")

                if response.statusCode == 200 {
                    completion(.success(true))
                } else {
                    if let responseBody = String(data: response.data, encoding: .utf8) {
                        print("❌ 서버 응답 본문: \(responseBody)")
                    }
                    let error = NSError(domain: "Profile Upload", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "업로드 실패"])
                    completion(.failure(error))
                }
            case .failure(let error):
                print("❌ 네트워크 요청 실패: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
