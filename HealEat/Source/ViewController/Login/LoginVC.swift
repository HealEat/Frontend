// Copyright © 2025 HealEat. All rights reserved.


import UIKit

class LoginVC: UIViewController {
    private let loginView = LoginView()

    // MARK: - Lifecycle
    override func loadView() {
        self.view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
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
        guard let url = URL(string: "https://healeatapp.com/auth/naver") else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    @objc private func kakaoLoginTapped() {
        print("카카오 로그인 버튼 눌림")
        navigateToProfile()
    }

    @objc private func appleLoginTapped() {
        print("Apple 로그인 버튼 눌림")
        navigateToProfile()
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

    private func navigateToProfile() {
        let profileVC = ProfileVC()
        profileVC.modalTransitionStyle = .crossDissolve
        profileVC.modalPresentationStyle = .fullScreen
        present(profileVC, animated: true, completion: nil)
    }

}
