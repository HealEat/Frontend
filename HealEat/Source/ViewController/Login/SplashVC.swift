// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import KeychainSwift

class SplashVC: UIViewController {
    // MARK: - Properties
    private let splashView = SplashView()
    let tokenPlugin = BearerTokenPlugin()

    // MARK: - Lifecycle
    override func loadView() {
        self.view = splashView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 현재 뷰 컨트롤러가 내비게이션 컨트롤러 안에 있는지 확인
        if self.navigationController == nil {
            // 네비게이션 컨트롤러가 없으면 새로 설정
            let navController = UINavigationController(rootViewController: self)
            navController.modalPresentationStyle = .fullScreen
            
            // 현재 창의 rootViewController 교체
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = navController
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.tokenPlugin.checkAuthenticationStatus() { token in
                if let token = token {
                    //self.navigateToBaseVC()
                    self.navigateToLoginVC() // 개발용 임시 코드
                } else {
                    self.navigateToLoginVC()
                }
            }
        }
    }
    

    // MARK: - Navigation
    func navigateToBaseVC() {
        let baseVC = BaseVC()
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = scene.windows.first {
            window.rootViewController = baseVC
            window.makeKeyAndVisible()
        }
    }
    
    private func navigateToLoginVC() {
        let loginVC = LoginVC()
        loginVC.modalTransitionStyle = .crossDissolve
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
}
