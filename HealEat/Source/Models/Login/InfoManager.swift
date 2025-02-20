// Copyright © 2025 HealEat. All rights reserved.

import Moya
import SwiftyToaster
import UIKit
import Combine

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



class InfoRepository {
    static let shared = InfoRepository()
    
    private init() { }
    
    private let provider = APIManager.InfoProvider
    
    func saveQuestion(questionNum: Int, param: InfoAnswerRequest) -> AnyPublisher<SavedAnswerResponseModel, HealEatError> {
        return provider.requestPublisher(.postInfo(questionNum: questionNum, param: param))
            .extractResult(SavedAnswerResponseEntity.self)
            .map({ SavedAnswerResponseModel(savedAnswerResponseEntity: $0) })
            .manageThread()
    }
    
    func searchDisease(keyword: String) -> AnyPublisher<[SearchResponseModel], HealEatError> {
        return provider.requestPublisher(.searchDisease(keyword: keyword))
            .extractResult([SearchResponseEntity].self)
            .map({ searchResponseEntities in
                return searchResponseEntities.map({ SearchResponseModel(searchResponseEntity: $0) })
            })
            .manageThread()
    }
    
    func saveDisease(diseaseRequest: DiseaseRequest) -> AnyPublisher<DiseaseResponseModel, HealEatError> {
        return provider.requestPublisher(.postDisease(param: diseaseRequest))
            .extractResult(DiseaseResponseEntity.self)
            .map({ DiseaseResponseModel(diseaseResponseEntity: $0) })
            .manageThread()
    }
}
