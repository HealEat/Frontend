// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import KeychainSwift
import SwiftyToaster

class LoginVC: UIViewController {
    let tokenPlugin = BearerTokenPlugin()
    private let loginView = LoginView()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(validateLogin), name: .loginSuccess, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Actions
    private func setupActions() {
        loginView.naverButton.addTarget(self, action: #selector(naverLoginTapped), for: .touchUpInside)
        loginView.kakaoButton.addTarget(self, action: #selector(kakaoLoginTapped), for: .touchUpInside)
        loginView.appleButton.addTarget(self, action: #selector(appleLoginTapped), for: .touchUpInside)
        loginView.skipButton.addTarget(self, action: #selector(skipLoginTapped), for: .touchUpInside)
    }

    @objc private func naverLoginTapped() {
        print("네이버 로그인 버튼 눌림")
        UserDefaults.standard.set("naver", forKey: "lastLoginPlatform")
        guard let url = URL(string: "https://healeatapp.com/auth/naver") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @objc private func kakaoLoginTapped() {
        print("카카오 로그인 버튼 눌림")
        UserDefaults.standard.set("kakao", forKey: "lastLoginPlatform")
        guard let url = URL(string: "https://healeatapp.com/auth/kakao") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @objc private func appleLoginTapped() {
        print("Apple 로그인 버튼 눌림")
        navigateToAgreement()
    }

    @objc private func skipLoginTapped() {
        // AlertController 생성
        let alertController = UIAlertController(
            title: nil,
            message: "로그인 없이 이용하실 경우 사용자의 건강에 맞춘 매장을 추천받으실 수 없습니다.\n로그인 없이 이용하시겠습니까?",
            preferredStyle: .alert
        )
        
        // "예" 버튼 추가
        let yesAction = UIAlertAction(title: "예", style: .default) { _ in
            print("로그인 없이 이용 선택됨")
            // 다음 화면으로 이동하거나 다른 로직 추가
            UserDefaults.standard.set(false, forKey: "isLoggedIn") // 로그인 상태 저장
            UserDefaults.standard.synchronize()
            self.navigateToBaseVC()
        }
        
        // "아니요" 버튼 추가
        let noAction = UIAlertAction(title: "아니요", style: .cancel) { _ in
            print("로그인 없이 이용 취소됨")
        }
        
        // 액션 추가
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        // AlertController 표시
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func validateLogin() {
        print("validateLogin")
        self.tokenPlugin.checkAuthenticationStatus() { [weak self] token in
            guard let self = self else { return }
            if let token = token {
                self.checkTermStatus { isAgreed in
                    //self.navigateToAgreement() // 개발용 임시 코드
                    if isAgreed {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn") // 로그인 상태 저장
                        UserDefaults.standard.synchronize()
                        NotificationCenter.default.post(name: .loginStatusChanged, object: nil) //  알림 보내기
                        
                        self.navigateToBaseVC() // 약관 동의했으면 홈 화면 이동
                    } else {
                        self.navigateToAgreement() // 동의 안 했으면 약관 동의 화면 이동
                    }
                }
            } else {
                Toaster.shared.makeToast("로그인에 실패했습니다.")
            }
        }
    }
    
    private func checkTermStatus(completion: @escaping (Bool) -> Void) {
        APIManager.AuthProvider.request(.getTermStatus) { result in
            switch result {
            case .success(let response):
                do {
                    let data = try JSONDecoder().decode(DefaultMultiResponse<TermStatusResponse>.self, from: response.data)
                    // 동의여부 하나만 확인
                    let isAgreed = data.result.first?.agree ?? false
                    completion(isAgreed)
                } catch {
                    print("❌ JSON 디코딩 오류: \(error.localizedDescription)")
                    completion(false)
                }
            case .failure(let error):
                print("❌ 이용약관 상태 조회 실패: \(error.localizedDescription)")
                Toaster.shared.makeToast("이용약관 동의 확인 중 에러가 발생했습니다.")
                completion(false)
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

    private func navigateToAgreement() {
        let TermsAgreementVC = TermsAgreementVC()
        TermsAgreementVC.modalTransitionStyle = .crossDissolve
        TermsAgreementVC.modalPresentationStyle = .fullScreen
        present(TermsAgreementVC, animated: true, completion: nil)
    }

    

    
    private func gotoHome() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
        let window = sceneDelegate.window else { return }

        let baseVC = BaseVC()
        window.rootViewController = baseVC
        window.makeKeyAndVisible()
    }
    
}
