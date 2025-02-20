// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class FinalStepVC: UIViewController {
    // MARK: - UI Elements
    private var messageLabel = UILabel().then {
        $0.text = "이용자님을 위한 추천 매장을 선정하고 있습니다."
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
    }

    private let subtitleLabel = UILabel().then {
        $0.text = "잠시만 기다려주세요!"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .center
        $0.textColor = .black
    }

    private let activityIndicator = UIActivityIndicatorView(style: .large).then {
        $0.color = .black
        $0.startAnimating()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        fetchProfile()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.animateTransitionToBaseVC()
        }
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        view.addSubview(messageLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(activityIndicator)

        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    //MARK: - API call
    private func fetchProfile(completion: (() -> Void)? = nil) {
        MyPageManager.getProfile { result in
            switch result {
            case .success(let profile):
                guard let data = profile.result else { return }
                DispatchQueue.main.async {
                    self.messageLabel.text = "\(data.name)님을 위한 추천 매장을 선정하고 있습니다."
                    completion?()
                }
            case .failure(let error):
                print("프로필 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Navigation
    private func animateTransitionToBaseVC() {
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0 
        }) { _ in
            self.navigateToBaseVC()
        }
    }

    private func navigateToBaseVC() {
        let baseVC = BaseVC()
        baseVC.modalPresentationStyle = .fullScreen
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = baseVC
            window.makeKeyAndVisible()
        }
    }
}




