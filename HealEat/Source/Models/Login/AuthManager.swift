// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SwiftyToaster
import Moya

class AuthManager {
    static func fetchTermsData(completion: @escaping (Result<DefaultMultiResponse<TermsResponse>, Error>) -> Void) {
        APIManager.AuthProvider.request(.getTerms) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultMultiResponse<TermsResponse>.self, from: response.data)
                    print(data)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
                }
                completion(.failure(error))
            }
        }
    }
    
    static func fetchTermsStatus(completion: @escaping (Result<Bool, Error>) -> Void) {
        APIManager.AuthProvider.request(.getTerms) { result in
            switch result {
            case .success(let response):
                do {
                    // JSON 데이터를 직접 디코딩하여 status 값만 추출
                    let data = try JSONDecoder().decode(DefaultResponse<[String: Bool]>.self, from: response.data)

                    if let status = data.result?["status"] {
                        completion(.success(status))
                    } else {
                        completion(.failure(NSError(domain: "fetchTermsStatus", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid status"])))
                    }
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }


}
