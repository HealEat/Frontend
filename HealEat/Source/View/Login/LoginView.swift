// Copyright © 2025 HealEat. All rights reserved.
import UIKit
import SnapKit
import Then

class LoginView: UIView {
    // MARK: - UI Elements
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "LogoImage")
        $0.contentMode = .scaleAspectFit
    }

    let naverButton = UIButton().then {
        $0.setTitle(" 네이버 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.backgroundColor = UIColor(hex: "#03C75A")
        $0.layer.cornerRadius = 8
        $0.contentHorizontalAlignment = .center

        let naverImage = UIImage(named: "NaverLogo")?.resize(to: CGSize(width: 18, height: 18))
        $0.setImage(naverImage, for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }

    let kakaoButton = UIButton().then {
        $0.setTitle(" 카카오 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.backgroundColor = UIColor(hex: "#FEE500")
        $0.layer.cornerRadius = 8
        $0.contentHorizontalAlignment = .center

        let kakaoImage = UIImage(named: "KakaoLogo")?.resize(to: CGSize(width: 21, height: 21))
        $0.setImage(kakaoImage, for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }

    let appleButton = UIButton().then {
        $0.setTitle(" Sign in with Apple", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
        $0.contentHorizontalAlignment = .center

        let appleImage = UIImage(named: "AppleLogo")?.resize(to: CGSize(width: 21, height: 21))
        $0.setImage(appleImage, for: .normal)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }

    let skipButton = UIButton().then {
        $0.setTitleColor(.gray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 11)

        let attributedString = NSAttributedString(
            string: "로그인 없이 이용하기",
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: UIColor.gray
            ]
        )
        $0.setAttributedTitle(attributedString, for: .normal)
    }

    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }

    private let spacerView = UIView()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View
    private func setupView() {
        addSubview(mainStackView)

        mainStackView.addArrangedSubview(logoImageView)
        mainStackView.addArrangedSubview(spacerView)
        mainStackView.addArrangedSubview(naverButton)
        mainStackView.addArrangedSubview(kakaoButton)
        mainStackView.addArrangedSubview(appleButton)
        mainStackView.addArrangedSubview(skipButton)

        setupConstraints()
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }

        [naverButton, kakaoButton, appleButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(42)
                make.width.equalTo(269)
            }
        }

        skipButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        spacerView.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
    }
}

// MARK: - UIImage Resize Extension
extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
