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
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func postAgreeToTerms(_ userParameter: TermsRequest, completion: @escaping (Bool, Response?) -> Void ) {
        APIManager.AuthProvider.request(.agreeToTerms(param: userParameter)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("이용약관 동의 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
        
    }
    



}
