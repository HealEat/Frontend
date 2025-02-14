







import UIKit
import SnapKit
import Then

class DiseaseManagementVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: PurposeCompletionDelegate?

    // MARK: - UI Elements
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
    }

    private let subtitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .center
        $0.textColor = .gray
    }

    private let searchTextField = UITextField().then {
        $0.placeholder = "질병 검색하기"
        $0.borderStyle = .roundedRect
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.clearButtonMode = .whileEditing
    }

    private let tableView = UITableView().then {
        $0.isHidden = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 10
    }

    private let options: [String] = [
        "체력/신체 기능 감소",
        "체중 감소",
        "소화 불량",
        "식욕 부진",
        "통증(두통, 관절통, 복통 등)",
        "만성 피로"
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

    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }

    // MARK: - Properties
    private var searchResults: [String] = []
    private var isStepTwo = false // ✅ 현재 상태 관리 (1단계/2단계)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupActions()
        setupTableView()
        updateUI(forStepTwo: false)
    }

    private func setupLayout() {
        view.addSubview(mainStackView)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(tableView)

        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(searchTextField)

        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        searchTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(searchTextField)
            make.height.equalTo(200)
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
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DiseaseCell")
    }

    private func updateUI(forStepTwo: Bool) {
        isStepTwo = forStepTwo

        if forStepTwo {
            titleLabel.text = "질병으로 인해 겪는 건강 상의 불편함은 무엇인가요?"
            subtitleLabel.text = "(중복 허용)"
            searchTextField.isHidden = true
            tableView.isHidden = true

            // 기존 옵션 버튼 제거 후 새롭게 추가
            optionButtons.forEach { $0.removeFromSuperview() }
            optionButtons.removeAll()

            options.forEach { option in
                let button = UIButton(type: .system).then {
                    $0.setTitle(option, for: .normal)
                    $0.setTitleColor(.black, for: .normal)
                    $0.layer.cornerRadius = 8
                    $0.layer.borderWidth = 1
                    $0.layer.borderColor = UIColor(hex: "#009459")?.cgColor
                    $0.backgroundColor = UIColor(hex: "#E8F5E9")
                    $0.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
                }
                optionButtons.append(button)
                mainStackView.addArrangedSubview(button)
            }

            // ✅ "다음" 버튼 유지
            if nextButton.superview == nil {
                view.addSubview(nextButton)
                nextButton.snp.makeConstraints { make in
                    make.trailing.equalToSuperview().inset(20)
                    make.bottom.equalToSuperview().inset(40)
                    make.width.equalTo(93)
                    make.height.equalTo(50)
                }
            }

        } else {
            titleLabel.text = "000 님의 질병은 무엇입니까?"
            searchTextField.isHidden = false
            tableView.isHidden = searchResults.isEmpty
        }
    }

    @objc private func previousButtonTapped() {
        if isStepTwo {
            updateUI(forStepTwo: false)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @objc private func nextButtonTapped() {
        if isStepTwo {
            dismiss(animated: true) {
                self.delegate?.didCompletePurpose()
            }
        } else {
            updateUI(forStepTwo: true)
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text, !query.isEmpty else {
            searchResults = []
            tableView.isHidden = true
            tableView.reloadData()
            return
        }

        let allDiseases = ["크론병", "당뇨병", "고혈압", "심장병"]
        searchResults = allDiseases.filter { $0.contains(query) }
        tableView.isHidden = searchResults.isEmpty
        tableView.reloadData()
    }

    @objc private func optionSelected(_ sender: UIButton) {
        sender.backgroundColor = sender.backgroundColor == UIColor(hex: "#009459")
            ? UIColor(hex: "#E8F5E9")
            : UIColor(hex: "#009459")
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiseaseCell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDisease = searchResults[indexPath.row]
        searchTextField.text = selectedDisease
        tableView.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
