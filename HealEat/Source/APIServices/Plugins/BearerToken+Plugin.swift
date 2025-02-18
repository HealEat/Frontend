// Copyright © 2025 HealEat. All rights reserved.

import Foundation
import Moya
import SwiftyToaster
import KeychainSwift
import UIKit

final class BearerTokenPlugin: PluginType {
    private var accessToken: String? {
        return KeychainSwift().get("accessToken")
    }
    
    func checkAuthenticationStatus(completion: @escaping (String?) -> Void) {
        guard let lastPlatform = UserDefaults.standard.string(forKey: "lastLoginPlatform"),
              let platform = LoginPlatform(rawValue: lastPlatform) else {
            print("🚨 저장된 로그인 플랫폼이 없음")
            completion(nil)
            return
        }
        
        guard let accessToken = KeychainSwift().get("accessToken"),
              let accessTokenCreatedMillis = KeychainSwift().get("accessTokenCreatedAt"),
              let createdMillis = Int64(accessTokenCreatedMillis) else {
            print("accessToken이 존재하지 않음. 로그인 필요.")
            completion(nil) // 로그인이 필요함을 알림
            return
        }
        
        let expiryMillis: Int64
        switch platform {
        case .naver:
            expiryMillis = createdMillis + (60 * 60 * 1000) // 🔹 네이버 (1시간)
        case .kakao:
            expiryMillis = createdMillis + (6 * 60 * 60 * 1000) // 🔹 카카오 (6시간)
        }
        
        let expiryDate = Date(milliseconds: expiryMillis)
        
        if Date() < expiryDate {
            print("✅ AccessToken 유효. 사용 가능.")
            completion(accessToken)
        } else {
            //forceLogout()
            completion(nil) // 재로그인 필요
        }
    }
    
    private func forceLogout() { // 무한 회귀
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = scene.windows.first {
                window.rootViewController = SplashVC()
                window.makeKeyAndVisible()
                print("스플래시 화면으로 이동")
            }
        }
    }


    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        let semaphore = DispatchSemaphore(value: 0)
        var tokenToAdd: String?

        checkAuthenticationStatus { token in
            tokenToAdd = token
            semaphore.signal()
        }
        
        semaphore.wait()
        
        if let token = tokenToAdd {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
}

