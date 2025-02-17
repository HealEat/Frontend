























import UIKit
import SnapKit
import Then

class SplashView: UIView {
    // MARK: - UI Elements
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "LogoImage") // Assets에 저장된 로고 이미지 이름
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white //배경흰색으로
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100) // 로고 크기 설정
        }
    }
}
