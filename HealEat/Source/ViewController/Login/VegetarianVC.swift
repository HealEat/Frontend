




import UIKit
import SnapKit
import Then

class VegetarianVC: UIViewController {
    weak var delegate: PurposeCompletionDelegate?
    
    // MARK: - UI Elements
    private let titleLabel = UILabel().then {
        $0.text = "000 님은 베지테리언 중 어떤 종류에 속하십니까?"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "* 프루테리언 제외"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textAlignment = .center
        $0.textColor = .gray
    }
    
    private let vegetarianOptions = [
        "플렉시테리언", "폴로-페스코", "페스코",
        "폴로", "락토-오보", "락토",
        "오보", "비건"
    ]
    
    private var optionButtons: [UIButton] = []
    
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
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }
    
    // 선택된 옵션 상태
    private var selectedOption: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
        setupLayout()
        setupActions()
    }
    
    private func setupButtons() {
        for option in vegetarianOptions {
            let button = UIButton(type: .system).then {
                $0.setTitle(option, for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.layer.cornerRadius = 8
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor(hex: "#009459")?.cgColor
                $0.backgroundColor = UIColor(hex: "#E8F5E9")
                $0.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
            }
            optionButtons.append(button)
        }
        
        optionButtons.forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(buttonStackView)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        optionButtons.forEach { button in
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
    
    private func setupActions() {
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Action Handlers
    @objc private func optionTapped(_ sender: UIButton) {
        optionButtons.forEach { button in
            button.backgroundColor = UIColor(hex: "#E8F5E9")
            button.setTitleColor(.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor(hex: "#009459")
        sender.setTitleColor(.white, for: .normal)
        
        selectedOption = sender.currentTitle
    }
    
    @objc private func previousButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func nextButtonTapped() {
        guard let selectedOption = selectedOption else {
            print("옵션을 선택하세요")
            return
        }

        // ✅ 선택한 베지테리언 타입 저장 (로컬)
        UserDefaults.standard.set(selectedOption, forKey: "vegetarianType")

        // ✅ API 요청 실행 (선택한 베지테리언 타입 PATCH 요청)
        VegetarianService.shared.updateVegetarianType(type: selectedOption) { result in
            switch result {
            case .success:
                print("✅ 베지테리언 타입 업데이트 성공!")

                DispatchQueue.main.async {
                    if selectedOption == "플렉시테리언" {
                        // ✅ 플렉시테리언이면 NEED 질문 진행
                        let needDietVC = NeedDietVC()
                        needDietVC.delegate = self.delegate
                        needDietVC.modalPresentationStyle = .fullScreen
                        self.present(needDietVC, animated: true, completion: nil)
                    } else {
                        // ✅ 플렉시테리언 제외 베지테리언이면 바로 FinalStep 이동
                        let finalStepVC = FinalStepVC()
                        finalStepVC.modalPresentationStyle = .fullScreen
                        self.present(finalStepVC, animated: true, completion: nil)
                    }
                }

            case .failure(let error):
                print("❌ 업데이트 실패: \(error.localizedDescription)")
            }
        }
    }
}
