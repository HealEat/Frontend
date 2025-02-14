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
        $0.image = UIImage(named: "ProfileImage")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .lightGray
    }

    let addButton = UIImageView().then {
        $0.image = UIImage(named: "PlusCircle")
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
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
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged) // ✅ 추가
    }

    let errorLabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .center
        $0.textColor = .red
        $0.isHidden = true
    }

    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }

    let nextButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.backgroundColor = UIColor(hex: "#E8F5E9")
        $0.setTitleColor(UIColor(hex: "#009459"), for: .normal)
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.alpha = 0.5
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        addSubview(stackView)
        addSubview(nextButton)
        addSubview(addButton)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(nicknameTextField)
        stackView.addArrangedSubview(errorLabel)

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        profileImageView.layer.cornerRadius = 50

        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.equalTo(profileImageView.snp.trailing).offset(5)
            make.top.equalTo(profileImageView.snp.top).offset(-5)
        }

        nicknameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(40)
        }

        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.width.equalTo(93)
            make.height.equalTo(50)
        }
    }

    // MARK: - TextField 변경 감지
    @objc private func textFieldDidChange() {
        updateNextButtonState()
    }

    // ✅ 닉네임 입력 여부에 따라 nextButton 상태 업데이트
    func updateNextButtonState() {
        let isNicknameEntered = !(nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        nextButton.isEnabled = isNicknameEntered
        nextButton.alpha = isNicknameEntered ? 1.0 : 0.5
    }
}
