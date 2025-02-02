// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit
import Then

class NeedToAvoidVC: UIViewController {
    weak var delegate: PurposeCompletionDelegate?

    private let titleLabel = UILabel().then {
        $0.text = "질병 관리를 위해 피해야 하는 음식이 있나요?"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
    }

    private let subtitleLabel = UILabel().then {
        $0.text = "(중복 허용)"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.textAlignment = .center
    }

    private let options = ["유제품", "밀가루", "날고기/생선", "육류", "카페인", "주류"]
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButtons()
        setupLayout()
        setupActions()
    }

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

    private func setupLayout() {
        view.addSubview(mainStackView)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
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

    @objc private func optionSelected(_ sender: UIButton) {
        sender.backgroundColor = sender.backgroundColor == UIColor(hex: "#009459")
            ? UIColor(hex: "#E8F5E9")
            : UIColor(hex: "#009459")
    }

    @objc private func previousButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func nextButtonTapped() {
        let needNutrientVC = FinalStepVC()
        needNutrientVC.modalPresentationStyle = .fullScreen
        present(needNutrientVC, animated: true, completion: nil)
    }
}
