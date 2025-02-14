


import UIKit
import SnapKit
import Then

class DietVC: UIViewController {
    weak var delegate: PurposeCompletionDelegate?

    // MARK: - UI Elements
    private let titleLabel = UILabel().then {
        $0.text = "000 님의 다이어트 목적은 무엇입니까?"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
    }

    private let weightLossButton = UIButton().then {
        $0.setTitle("체중 감량", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#009459")?.cgColor
        $0.backgroundColor = UIColor(hex: "#E8F5E9")
    }

    private let healthMaintenanceButton = UIButton().then {
        $0.setTitle("건강 유지", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#009459")?.cgColor
        $0.backgroundColor = UIColor(hex: "#E8F5E9")
    }

    private let previousButton = UIButton().then {
        $0.setTitle("이전", for: .normal)
        $0.backgroundColor = UIColor.lightGray
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }

    private let nextButton = UIButton().then {
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

    // 선택된 옵션 저장
    private var selectedOption: String?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupActions()
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        view.addSubview(mainStackView)
        view.addSubview(previousButton)
        view.addSubview(nextButton)

        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(weightLossButton)
        mainStackView.addArrangedSubview(healthMaintenanceButton)

        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        [weightLossButton, healthMaintenanceButton].forEach { button in
            button.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
        }

        previousButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.width.equalTo(93)
            make.height.equalTo(50)
        }

        nextButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.width.equalTo(93)
            make.height.equalTo(50)
        }
    }

    // MARK: - Setup Actions
    private func setupActions() {
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        [weightLossButton, healthMaintenanceButton].forEach { button in
            button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
        }
    }

    // MARK: - Action Handlers
    @objc private func previousButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func nextButtonTapped() {
        guard let selectedOption = selectedOption else {
            print("목적을 선택해주세요.") // 선택되지 않은 경우
            return
        }

        // ✅ API 요청 실행 (선택한 다이어트 목적 PATCH 요청)
        DietService.shared.updateDietType(type: selectedOption) { result in
            switch result {
            case .success:
                print("✅ 다이어트 목적 업데이트 성공!")
                DispatchQueue.main.async {
                    // ✅ 선택한 다이어트 목적 저장
                    UserDefaults.standard.set(selectedOption, forKey: "dietPurpose")

                    print("선택된 다이어트 목적: \(selectedOption)")

                    let hasDiseaseManagement = UserDefaults.standard.bool(forKey: "hasDiseaseManagement")

                    if selectedOption == "체중 감량" && !hasDiseaseManagement {
                        // ✅ 체중 감량 선택 & 질병 관리가 선택되지 않았다면 NeedDiet을 스킵
                        let needNutrientVC = NeedNutrientVC()
                        needNutrientVC.delegate = self.delegate
                        needNutrientVC.modalPresentationStyle = .fullScreen
                        self.present(needNutrientVC, animated: true, completion: nil)
                    } else {
                        // ✅ 기존 방식대로 NeedDietVC로 이동
                        let needDietVC = NeedDietVC()
                        needDietVC.delegate = self.delegate
                        needDietVC.modalPresentationStyle = .fullScreen
                        self.present(needDietVC, animated: true, completion: nil)
                    }
                }

            case .failure(let error):
                print("❌ 다이어트 목적 업데이트 실패: \(error.localizedDescription)")
            }
        }
    }


    @objc private func optionButtonTapped(_ sender: UIButton) {
        // 모든 버튼 상태 초기화
        [weightLossButton, healthMaintenanceButton].forEach { button in
            button.backgroundColor = UIColor(hex: "#E8F5E9")
            button.setTitleColor(.black, for: .normal)
        }

        // 선택된 버튼 활성화
        sender.backgroundColor = UIColor(hex: "#009459")
        sender.setTitleColor(.white, for: .normal)

        // 선택된 옵션 저장
        selectedOption = sender.title(for: .normal)
    }
}
