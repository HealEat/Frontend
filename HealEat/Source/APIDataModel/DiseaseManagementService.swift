














import Moya
import Foundation

class DiseaseManagementService {
    private let provider = MoyaProvider<DiseaseServiceAPI>()

    // ✅ 질병 자동완성 API 호출
    func searchDisease(keyword: String, completion: @escaping ([String]) -> Void) {
        provider.request(.searchDisease(keyword: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    if let resultArray = json?["result"] as? [[String: Any]] {
                        let diseaseNames = resultArray.compactMap { $0["name"] as? String }
                        completion(diseaseNames)
                    } else {
                        print("❌ No 'result' key in response JSON")
                        completion([])
                    }
                } catch {
                    print("❌ JSON Parsing Error: \(error.localizedDescription)")
                    completion([])
                }
            case .failure(let error):
                print("❌ API Request Error: \(error.localizedDescription)")
                completion([])
            }
        }
    }

    // ✅ 선택한 질병을 서버로 PATCH 요청
    func updateDisease(diseaseName: String, completion: @escaping (Bool) -> Void) {
        provider.request(.addDisease(diseaseName: diseaseName)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    let isSuccess = json?["isSuccess"] as? Bool ?? false
                    
                    if isSuccess {
                        print("✅ Successfully updated disease: \(diseaseName)")
                    } else {
                        print("⚠️ Failed to update disease: \(diseaseName) - Response: \(json ?? [:])")
                    }
                    
                    completion(isSuccess)
                } catch {
                    print("❌ JSON Parsing Error: \(error.localizedDescription)")
                    completion(false)
                }
            case .failure(let error):
                print("❌ PATCH Request Error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
