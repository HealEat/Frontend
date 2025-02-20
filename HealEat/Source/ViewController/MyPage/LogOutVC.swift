// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import KeychainSwift
import SwiftyToaster
import Moya
import Then

class LogOutVC: UIViewController {

    
    // MARK: - UI Properties
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    private lazy var label = UILabel().then {
        $0.text = "정말 로그아웃 하시겠습니까?"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
    private lazy var logOutButton = UIButton().then {
        $0.setTitle("예", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.backgroundColor = .healeatGray3
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 12
    }
    private lazy var dismissButton = UIButton().then {
        $0.setTitle("아니요", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.backgroundColor = .healeatGray3
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
    
    
    // MARK: - UI Methods
    private func setUp() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        view.addSubview(containerView)
        [label, logOutButton, dismissButton].forEach {
            containerView.addSubview($0)
        }
        containerView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.74)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.center.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.8)
        }
        logOutButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.4)
            make.centerX.equalToSuperview().multipliedBy(0.6)
            make.width.equalTo(95)
            make.height.equalTo(34)
        }
        dismissButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.4)
            make.centerX.equalToSuperview().multipliedBy(1.4)
            make.width.equalTo(95)
            make.height.equalTo(34)
        }
        
        logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)

    }
    
    //MARK: - Setup Actions
    @objc private func dismissTapped() {
        dismiss(animated: true)
    }


    //MARK: - API call
    @objc private func logOut() {
        print("logout tapped")
        APIManager.AuthProvider.request(.logout) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    UserDefaults.standard.removeObject(forKey: "lastLoginPlatform")
                    KeychainSwift().delete("accessToken")
                    KeychainSwift().delete("accessTokenCreatedAt")
                    self.showSplashVC()
                } else {
                    print("로그아웃 중 에러")
                }
            case .failure(let error):
                Toaster.shared.makeToast("로그아웃 중 에러가 발생했습니다.")
            }
        }
    }
    

    func showSplashVC() {
        let splashVC = SplashVC()
        
        // 현재 윈도우 가져오기
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first else {
            print("윈도우를 가져올 수 없습니다.")
            return
        }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = splashVC
        }, completion: nil)
    }

}

