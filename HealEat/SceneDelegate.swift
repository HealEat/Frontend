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
        
        let marketVC = MarketVC()
        marketVC.param = MarketVC.Param(storeResponseModel: StoreResponseModel(
            placeId: 99,
            placeName: "본죽&비빔밥cafe 홍대점 (테스트)",
            categoryName: "죽",
            phone: "010-1234-5678",
            addressName: "서울 마포구 홍익로 10 106호",
            roadAddressName: "서울 마포구 홍익로 10 106호",
            x: "37.553851",
            y: "126.923388",
            placeUrl: URL(string: "https://place.map.kakao.com/287510690")!,
            features: ["속 편한 음식", "야채", "죽", "따뜻한 음식"],
            imageUrls: [
                URL(string: "https://lv2-cdn.azureedge.net/jypark/f8ba911ed379439fbe831212be8701f9-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20Conceptphoto03(Clean).jpg")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/4bdca5fcc29c48c08071eaaa5cd43e79-231103%206PM%20%EB%B0%95%EC%A7%84%EC%98%81%20%ED%94%84%EB%A1%9C%ED%95%84%20%EC%82%AC%EC%A7%84.jpg")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/0.jpg")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/gallery_150125165011.jpg")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/c726ced3865543a296dde99424fda29c-Still%20Alive.jpg")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/9b145cd47f4f40df8c62ab3af0b60fcb-JYP-Groove%20Missing-OnlineCover.png")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/9e9bc12fbb24494d98695ac1fa8be153-JYP_Groove%20Missing_%ED%8B%B0%EC%A0%80%ED%81%B4%EB%A6%B0%EB%B3%B8_02.jpg")!,
                URL(string: "https://lv2-cdn.azureedge.net/jypark/9726350cf1224be19c2d8c7d64710d32-JYP_Groove%20Missing_%ED%8B%B0%EC%A0%80%ED%81%B4%EB%A6%B0%EB%B3%B8_01.jpg")!,
            ],
            isInDB: true,
            totalScore: 4.4,
            reviewCount: 23,
            sickScore: 4.7,
            sickCount: 15,
            vegetScore: 3.4,
            vegetCount: 13,
            dietScore: 4.3,
            dietCount: 5,
            isBookMarked: false
        ))
        window?.rootViewController = UINavigationController(rootViewController: marketVC)
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
