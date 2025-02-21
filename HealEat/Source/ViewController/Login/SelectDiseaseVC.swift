// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Combine

class SelectDiseaseVC: UIViewController {
    
    private var searchResults: [String] = []
    
    private var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private(set) var textFieldEvent = PassthroughSubject<String, Never>()
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    private let searchTextField = UITextField().then {
        $0.placeholder = "질병 검색하기"
        $0.borderStyle = .roundedRect
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.clearButtonMode = .whileEditing
    }
    
    private let previousButton = UIButton().then {
        $0.setTitle("이전", for: .normal)
        $0.tintColor = .healeatGreen1
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.layer.cornerRadius = 10
    }
    
    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = UIColor(hex: "#009459")
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }
    
    private let addButton = UIButton().then {
        $0.setTitle("질병추가", for: .normal)
        $0.backgroundColor = UIColor.healeatGray3
        $0.setTitleColor(UIColor.healeatGray5, for: .normal)
        $0.layer.cornerRadius = 10
    }
    
    private let diseaseStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let searchStackView = UIStackView().then {
        $0.backgroundColor = .white
        $0.axis = .vertical
        $0.spacing = 0
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        hideKeyboardWhenTappedAround()
        textFieldEvent
            .debounce(for: 1, scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] text in
                print(text)
                self?.search(text: text)
            })
            .store(in: &cancellable)
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupLayout() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(diseaseStackView)
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(searchStackView)
        
        diseaseStackView.addArrangedSubview(searchTextField)
        
        previousButton.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(16)
        })
        diseaseStackView.snp.makeConstraints({ make in
            make.top.equalTo(view.snp.centerY)
            make.leading.trailing.equalToSuperview().inset(64)
        })
        searchStackView.snp.makeConstraints({ make in
            make.top.equalTo(diseaseStackView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(64)
        })
        nextButton.snp.makeConstraints({ make in
            make.top.equalTo(diseaseStackView.snp.bottom).offset(22)
            make.trailing.equalToSuperview().inset(45)
            make.width.equalTo(74)
            make.height.equalTo(36)
        })
        addButton.snp.makeConstraints({ make in
            make.top.equalTo(diseaseStackView.snp.bottom).offset(22)
            make.trailing.equalTo(nextButton.snp.leading).offset(-5)
            make.width.equalTo(74)
            make.height.equalTo(36)
        })
    }
    
    private func search(text: String) {
        searchStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        InfoRepository.shared.searchDisease(keyword: text)
            .sinkHandledCompletion(receiveValue: { searchResponseModels in
                print(searchResponseModels)
                searchResponseModels.forEach({ searchResponseModel in
                    let button = UIButton()
                    button.setTitleColor(.healeatBlack, for: .normal)
                    button.setTitle(searchResponseModel.name, for: .normal)
                    button.addTarget(self, action: #selector(self.keywordClicked), for: .touchUpInside)
                    self.searchStackView.addArrangedSubview(button)
                
                })
            })
            .store(in: &cancellable)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        textFieldEvent.send(textField.text ?? "")
    }
    
    @objc private func nextButtonTapped() {
        guard let searchResult = searchResults.first else { return }
        InfoRepository.shared.saveDisease(diseaseRequest: DiseaseRequest(diseaseName: searchResult))
            .sinkHandledCompletion(receiveValue: { diseaseResponseModel in
                print(diseaseResponseModel)
                guard let parent = self.parent as? QuestionBaseVC else { return }
                parent.viewControllers[.sick]?.removeAll(where: { $0 == .selectDisease })
                parent.setupContainerViewController()
            })
            .store(in: &cancellable)
    }
    
    @objc private func keywordClicked(_ sender: UIButton) {
        searchStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        guard let title = sender.title(for: .normal) else { return }
        
        searchResults.append(title)
        let label = UILabel().then {
            $0.text = title
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.snp.makeConstraints({ make in
                make.height.equalTo(40)
            })
        }
        diseaseStackView.insertArrangedSubview(label, at: 0)
        searchTextField.text = ""
    }
}
