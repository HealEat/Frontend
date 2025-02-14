// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import SwiftyToaster

class CSearchManager {
    static func recentSearches(completion: @escaping (Result<DefaultResponse<RecentSearchResponse> , Error>) -> Void) {
        APIManager.CSearchProvider.request(.searchRecent) {
            result in
            switch result {
            case .success(let response):
                do {
                    let data = try response.map(DefaultResponse<RecentSearchResponse>.self)
                    completion(.success(data))
                } catch {
                    print(response)
                    completion(.failure(error))
                }
            case .failure(let error):
                Toaster.shared.makeToast("최근 검색 기록 불러오기 중 에러가 발생했습니다.")
                completion(.failure(error)) // 네트워크 실패 전달
            }
        }
    }

    
    static func deleteRecentSearch(recentId: Int, completion: @escaping (Bool, Response?) -> Void ) {
        APIManager.CSearchProvider.request(.deleteRecentSearch(recentId: recentId)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                Toaster.shared.makeToast("최근 검색 기록 삭제 중 에러가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
    static func search(page: Int, param: CSearchRequest, completion: @escaping (Bool, HomeResponse?) -> Void) {
        APIManager.CSearchProvider.request(.search(page: page, param: param)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let decodedData = try JSONDecoder().decode(DefaultResponse<HomeResponse>.self, from: response.data)
                        completion(true, decodedData.result) // ✅ 성공 시, 디코딩된 데이터 반환
                    } catch {
                        print("❌ JSON 디코딩 오류:", error)
                        completion(false, nil)
                    }
                } else {
                    if let errorString = String(data: response.data, encoding: .utf8) {
                        print("❌ 서버 응답 에러 메시지: \(errorString)") // ✅ 서버 메시지 출력
                    }
                    completion(false, nil)
                }

            case .failure(let error):
                print("❌ 맞춤 검색 API 요청 실패: \(error.localizedDescription)")
                Toaster.shared.makeToast("맞춤 검색 중 에러가 발생했습니다.")
                completion(false, nil)
            }
        }
    }



}



