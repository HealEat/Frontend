import UIKit
import SnapKit
import Then

class LoginView: UIView {
    // MARK: - UI Elements
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "LogoImage") // 로고 이미지 설정
        $0.contentMode = .scaleAspectFit
    }

    let naverButton = UIButton().then {
        $0.setTitle("네이버로 시작하기", for: .normal)
        $0.backgroundColor = UIColor(hex: "#DEDEDE")
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    let kakaoButton = UIButton().then {
        $0.setTitle("카카오로 시작하기", for: .normal)
        $0.backgroundColor = UIColor(hex: "#DEDEDE")
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    let appleButton = UIButton().then {
        $0.setTitle("apple로 시작하기", for: .normal)
        $0.backgroundColor = UIColor(hex: "#DEDEDE")
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    let skipButton = UIButton().then {
        $0.setTitleColor(.gray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        
        // 밑줄 추가
        let attributedString = NSAttributedString(
            string: "로그인 없이 이용하기",
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue, // 밑줄 스타일
                .foregroundColor: UIColor.gray // 텍스트 색상 설정
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

    private let spacerView = UIView() // 로고와 첫 번째 버튼 사이에 간격을 추가할 뷰
    
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

        // StackView에 로고 및 버튼 추가
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
        // 메인 스택뷰 중앙 정렬
        mainStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // X축 중앙 정렬
            make.centerY.equalToSuperview() // Y축 중앙 정렬
        }

        // 로고 이미지 크기 설정
        logoImageView.snp.makeConstraints { make in
            make.height.equalTo(120) // 로고 높이
        }

        // 버튼 높이 설정
        [naverButton, kakaoButton, appleButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(42) // 버튼 Y축 길이
                make.width.equalTo(269)
            }
        }

        // 스킵 버튼 높이 설정 (다른 버튼들과 차별화 가능)
        skipButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        spacerView.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
    }
    
}
