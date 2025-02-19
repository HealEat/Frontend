// Copyright © 2025 HealEat. All rights reserved.

import Moya
import Foundation
import Moya

enum ProfileAPI {
    case createProfile(name: String, image: Data?)
}

extension ProfileAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.NetworkManager.baseURL) else {
            fatalError("fatal error - invalid url")
        }
        return url
    }

    var path: String {
        switch self {
        case .createProfile:
            return "info/profile"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createProfile:
            return .post 
        }
    }

    var task: Task {
        switch self {
        case .createProfile(let name, let image):
            var multipartData: [MultipartFormData] = []

            // 닉네임 JSON 데이터 추가
            if let jsonData = try? JSONSerialization.data(withJSONObject: ["name": name], options: []) {
                multipartData.append(MultipartFormData(provider: .data(jsonData), name: "request"))
            }
            // 이미지 파일 추가
            if let imageData = image {
                multipartData.append(MultipartFormData(provider: .data(imageData), name: "file", fileName: "profile.jpg", mimeType: "image/jpeg"))
            }

            return .uploadMultipart(multipartData)
        }
    }

    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "multipart/form-data"]
        }
        
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
