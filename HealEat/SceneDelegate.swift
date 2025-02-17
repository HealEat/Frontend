// Copyright © 2025 HealEat. All rights reserved.


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // UIWindowScene을 가져옵니다.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // UIWindow 생성
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        // SplashVC를 초기화면으로 설정
//        let splashVC = SplashVC() // SplashViewController -> SplashVC로 변경
//        window?.rootViewController = splashVC
//        let baseVC = BaseVC()
//        window?.rootViewController = baseVC
        let marketVC = MarketVC()
        marketVC.param = MarketVC.Param(placeId: 13284457)
        window?.rootViewController = UINavigationController(rootViewController: marketVC)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        // NAVER LOGIN
        guard let url = URLContexts.first?.url, let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        let message = urlComponents.queryItems?.first(where: { $0.name == "message" })?.value
        let accessToken = urlComponents.queryItems?.first(where: { $0.name == "accessToken" })?.value
        
        print(message)
        print(accessToken)
    }
}
