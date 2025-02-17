























import UIKit
import SnapKit
import Then

class NeedNutrientVC: UIViewController {
    weak var delegate: PurposeCompletionDelegate?
    
    private let nutrientService = NeedNutrientService()

    private let backButton = UIButton().then {
        $0.setTitle("< 이전", for: .normal)
        $0.setTitleColor(UIColor(hex: "#009459"), for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.contentHorizontalAlignment = .left
    }

    private let titleLabel = UILabel().then {
        $0.text = "건강 관리를 위해 특별히 필요한 영양소가 있나요?"
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.numberOfLines = 2
    }

    private let subtitleLabel = UILabel().then {
        $0.text = "(중복선택가능)"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.textAlignment = .center
    }

    private let options = ["탄수화물", "단백질", "지방", "비타민", "무기질", "섬유소"]
    private var selectedOptions: Set<String> = []

    private var optionButtons: [UIButton] = []

    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = UIColor(hex: "#E8F5E9")
        $0.setTitleColor(UIColor(hex: "#009459"), for: .normal) // ✅ 초록색 텍스트
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.alpha = 0.5
    }

    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupOptions()
        setupLayout()
        setupActions()
    }

    // MARK: - Setup Options
    private func setupOptions() {
        for title in options {
            let button = UIButton(type: .system).then {
                $0.setTitle(title, for: .normal)
                $0.setTitleColor(.lightGray, for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                $0.layer.cornerRadius = 12
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor.lightGray.cgColor
                $0.backgroundColor = .white
                $0.contentHorizontalAlignment = .left

                let imageSize: CGFloat = 20
                $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
                $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 0)

                $0.setImage(UIImage(systemName: "circle"), for: .normal)
                $0.tintColor = .gray
                $0.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            }
            optionButtons.append(button)
            mainStackView.addArrangedSubview(button)
        }
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        view.addSubview(backButton)
        view.addSubview(mainStackView)

        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(16)
        }

        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subtitleLabel)

        optionButtons.forEach { mainStackView.addArrangedSubview($0) }

        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(60)
        }

        optionButtons.forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        }

        // ✅ "다음" 버튼을 Stack 바로 아래에 배치
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(36) // ✅ 높이 36
            make.width.equalTo(74)  // ✅ 너비 74
            make.trailing.equalToSuperview().inset(20) // ✅ 오른쪽 정렬
            make.top.equalTo(mainStackView.snp.bottom).offset(10) // ✅ Stack 바로 아래 위치
        }
    }

    // MARK: - Setup Actions
    private func setupActions() {
        backButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    // MARK: - Action Handlers
    @objc private func optionSelected(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }

        if selectedOptions.contains(title) {
            selectedOptions.remove(title)
            sender.backgroundColor = .white
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
            sender.tintColor = .gray
            sender.setTitleColor(.lightGray, for: .normal)
        } else {
            selectedOptions.insert(title)
            sender.backgroundColor = UIColor(hex: "#E8F5E9")
            sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            sender.tintColor = UIColor(hex: "#009459")
            sender.setTitleColor(.black, for: .normal)
        }

        nextButton.isEnabled = !selectedOptions.isEmpty
        nextButton.alpha = selectedOptions.isEmpty ? 0.5 : 1.0
    }

    @objc private func previousButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func nextButtonTapped() {
        guard !selectedOptions.isEmpty else {
            print("옵션을 선택해주세요.")
            return
        }
        
        sendSelectedNutrientOptions()
        
        let needToAvoidVC = NeedToAvoidVC()
        needToAvoidVC.modalPresentationStyle = .fullScreen
        present(needToAvoidVC, animated: true, completion: nil)
    }
    
    private func sendSelectedNutrientOptions() {
        let selectedArray = Array(selectedOptions)
        
        nutrientService.sendNutrientPreference(selectedAnswers: selectedArray) { success in
            DispatchQueue.main.async {
                if success {
                    print("✅ 선택된 영양소 옵션 전송 성공: \(selectedArray)")

                    // ✅ 성공 시 다음 화면으로 이동
                    let needToAvoidVC = NeedToAvoidVC()
                    needToAvoidVC.modalPresentationStyle = .fullScreen
                    self.present(needToAvoidVC, animated: true, completion: nil)
                } else {
                    print("❌ 선택된 영양소 옵션 전송 실패")
                }
            }
        }
    }
}
