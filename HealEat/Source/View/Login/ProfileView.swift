import UIKit
import SnapKit
import Then

class ProfileView: UIView {

    // MARK: - UI Elements
    let titleLabel = UILabel().then {
        $0.text = "어플 내에서 사용하실 프로필을 작성해주세요!"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        $0.textAlignment = .center
        $0.textColor = .black
    }

    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "ProfileImage") // 기본 이미지
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true // 이미지가 원형 안에 들어오도록 설정
        $0.isUserInteractionEnabled = true // 사용자 인터랙션 활성화
        $0.backgroundColor = .lightGray
    }

    let addButton = UIImageView().then {
        $0.image = UIImage(named: "PlusCircle") // Assets에 추가된 PlusCircle 이미지
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true // 사용자 인터랙션 활성화
    }

    let nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임 입력하기"
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textAlignment = .center
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.clipsToBounds = true
        $0.clearButtonMode = .whileEditing
    }

    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = UIColor(hex: "#009459")
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white //배경흰색
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        addSubview(stackView)
        addSubview(nextButton)
        addSubview(addButton) // addButton을 view에 직접 추가

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(nicknameTextField)

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        profileImageView.layer.cornerRadius = 50 // 원형으로 설정

        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(30) // PlusButton 크기
            make.trailing.equalTo(profileImageView.snp.trailing).offset(5) // 오른쪽 바깥
            make.top.equalTo(profileImageView.snp.top).offset(-5) // 위쪽 바깥
        }

        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }

        nicknameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
        }
    }
}
