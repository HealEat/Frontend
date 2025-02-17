























import UIKit
import SnapKit
import Then

class PurposeView: UIView {
    // MARK: - UI Elements
    private let titleLabel = UILabel().then {
        $0.text = "이 어플을 사용하는 목적이 무엇인가요?"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
    }

    private let subtitleLabel = UILabel().then {
        $0.text = "(중복허용)"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textAlignment = .center
        $0.textColor = .gray
    }

    // 개별 버튼 선언
    let diseaseManagementButton = UIButton().then {
        $0.setTitle("질병 관리", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#009459")?.cgColor
        $0.backgroundColor = UIColor(hex: "#E8F5E9")
    }

    let vegetarianButton = UIButton().then {
        $0.setTitle("베지테리언", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#009459")?.cgColor
        $0.backgroundColor = UIColor(hex: "#E8F5E9")
    }

    let dietButton = UIButton().then {
        $0.setTitle("다이어트", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#009459")?.cgColor
        $0.backgroundColor = UIColor(hex: "#E8F5E9")
    }

    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = UIColor(hex: "#009459")
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }

    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .white
        setupButtonActions() // 버튼 동작 추가
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup View
    private func setupView() {
        addSubview(mainStackView)
        addSubview(nextButton)

        // 라벨과 버튼들을 mainStackView에 추가
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(diseaseManagementButton)
        mainStackView.addArrangedSubview(vegetarianButton)
        mainStackView.addArrangedSubview(dietButton)

        setupConstraints()
    }

    // MARK: - Setup Constraints
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview() // X, Y축 모두 중앙 정렬
        }

        [diseaseManagementButton, vegetarianButton, dietButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(56)
                make.width.equalTo(268)
            }
        }

        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.width.equalTo(93)
            make.height.equalTo(50)
        }
    }

    // MARK: - Button States
    private var selectedButtons: [UIButton] = [] // 선택된 버튼들 저장

    private func setupButtonActions() {
        diseaseManagementButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        vegetarianButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        dietButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        if selectedButtons.contains(sender) {
            // 버튼이 이미 선택되어 있다면 선택 해제
            selectedButtons.removeAll { $0 == sender }
            updateButtonState(sender, isSelected: false)
        } else {
            // 버튼 선택
            selectedButtons.append(sender)
            updateButtonState(sender, isSelected: true)
        }
    }

    private func updateButtonState(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            button.backgroundColor = UIColor(hex: "#C8E6C9") // 선택된 배경색
            button.layer.borderColor = UIColor(hex: "#007E33")?.cgColor // 선택된 테두리색
        } else {
            button.backgroundColor = UIColor(hex: "#E8F5E9") // 기본 배경색
            button.layer.borderColor = UIColor(hex: "#009459")?.cgColor // 기본 테두리색
        }
    }
}
