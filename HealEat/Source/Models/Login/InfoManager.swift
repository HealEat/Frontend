// Copyright © 2025 HealEat. All rights reserved.

import Moya
import SwiftyToaster
import UIKit

class InfoManager {
    
    
    static func saveProfile(_ userParameter: InfoProfileRequest, completion: @escaping (Bool, Response?) -> Void) {
        APIManager.InfoProvider.request(.postProfile(param: userParameter)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("프로필 저장 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }

    
    
    

    
    
    
}



