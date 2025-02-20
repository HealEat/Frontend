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
        guard let accessToken = KeychainSwift().get("accessToken"),
              let accessTokenCreatedMillis = KeychainSwift().get("accessTokenCreatedAt"),
              let createdMillis = Int64(accessTokenCreatedMillis) else {
            print("accessToken이 존재하지 않음. 로그인 필요.")
            completion(nil) // 로그인이 필요함을 알림
            return
        }
        
        let expiryMillis: Int64
        expiryMillis = createdMillis + (60 * 60 * 1000) // 1시간
        let expiryDate = Date(milliseconds: expiryMillis)
        
        if Date() < expiryDate {
            print("AccessToken 유효. 사용 가능.")
            completion(accessToken)
        } else {
            Toaster.shared.makeToast("재로그인 필요")
            completion(nil) // 재로그인 필요
        }
    }
    
    private func forceLogout() { // 무한 회귀, 쓰면 안됨
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

