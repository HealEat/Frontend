





import Foundation
import Moya

enum ProfileAPI {
    case createProfile(name: String, image: Data?)
}

extension ProfileAPI: TargetType {
    var baseURL: URL {
        return URL(string: "http://13.124.70.231:8080")!
    }

    var path: String {
        switch self {
        case .createProfile:
            return "/info/profile"
        }
    }

    var method: Moya.Method {
        switch self {
        case .createProfile:
            return .post  // ✅ POST 요청 사용
        }
    }

    var task: Task {
        switch self {
        case let .createProfile(name, image):
            var multipartData: [MultipartFormData] = []

            // 닉네임 JSON 데이터 추가
            let jsonData = try? JSONSerialization.data(withJSONObject: ["name": name], options: [])
            let jsonPart = MultipartFormData(provider: .data(jsonData ?? Data()), name: "request")
            multipartData.append(jsonPart)

            // 이미지 파일 추가
            if let imageData = image {
                let imagePart = MultipartFormData(provider: .data(imageData), name: "file", fileName: "profile.jpg", mimeType: "image/jpeg")
                multipartData.append(imagePart)
            }

            return .uploadMultipart(multipartData)
        }
    }

    var headers: [String: String]? {
        return [
            "accept": "*/*",
            "Authorization": "Bearer 9999",
            "Content-Type": "multipart/form-data"
        ]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
