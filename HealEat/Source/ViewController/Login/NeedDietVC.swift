// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class NeedDietVC: UIViewController {
    weak var delegate: PurposeCompletionDelegate?

    // MARK: - UI Elements
    private let titleLabel = UILabel().then {
        $0.text = "필요한 식단은 무엇인가요?"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
    }

    private let options = ["저탄수화물", "고단백", "저염식", "글루텐 프리"]
    private var selectedOption: String?

    private var optionButtons: [UIButton] = []

    private let previousButton = UIButton().then {
        $0.setTitle("이전", for: .normal)
        $0.backgroundColor = .lightGray
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
        setupLayout()
        setupActions()
    }

    // MARK: - Setup Buttons
    private func setupButtons() {
        for title in options {
            let button = UIButton(type: .system).then {
                $0.setTitle(title, for: .normal)
                $0.setTitleColor(.black, for: .normal)
                $0.layer.cornerRadius = 8
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor(hex: "#009459")?.cgColor
                $0.backgroundColor = UIColor(hex: "#E8F5E9")
                $0.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            }
            optionButtons.append(button)
        }

        optionButtons.forEach { mainStackView.addArrangedSubview($0) }
    }

    // MARK: - Setup Layout
    private func setupLayout() {
        view.addSubview(mainStackView)
        view.addSubview(previousButton)
        view.addSubview(nextButton)

        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
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

    // MARK: - Setup Actions
    private func setupActions() {
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    // MARK: - Action Handlers
    @objc private func optionSelected(_ sender: UIButton) {
        optionButtons.forEach { button in
            button.backgroundColor = UIColor(hex: "#E8F5E9")
            button.setTitleColor(.black, for: .normal)
        }

        sender.backgroundColor = UIColor(hex: "#009459")
        sender.setTitleColor(.white, for: .normal)
        selectedOption = sender.title(for: .normal)
    }

    @objc private func previousButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func nextButtonTapped() {
        guard selectedOption != nil else {
            print("옵션을 선택해주세요.")
            return
        }
        let needNutrientVC = NeedNutrientVC()
        needNutrientVC.modalPresentationStyle = .fullScreen
        present(needNutrientVC, animated: true, completion: nil)
    }
}
