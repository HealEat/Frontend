












import UIKit
import SnapKit
import Then
import Moya

class DiseaseManagementVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: PurposeCompletionDelegate?
    
    // Moya Provider 추가
    private let provider = MoyaProvider<DiseaseServiceAPI>()

    private let questionService = DiseaseQuestionService()
    
    private let nameService = GetNameService()  // ✅ 사용자 이름 가져오는 서비스 추가
    
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

    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }

    private let searchContainer = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .equalSpacing
    }

    private var searchFields: [UITextField] = []
    
    private let tableView = UITableView().then {
        $0.isHidden = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 10
    }

    private let addButton = UIButton().then {
        $0.setTitle("질병 추가", for: .normal)
        $0.backgroundColor = UIColor(hex: "#009459")
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(addSearchField), for: .touchUpInside)
    }

    private let previousButton = UIButton().then {
        $0.setTitle("이전", for: .normal)
        $0.backgroundColor = UIColor.lightGray
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
    }

    private let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = UIColor(hex: "#009459")
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    // ✅ Step 2에서 선택할 옵션들
    private let options: [String] = [
        "체력/신체 기능 감소",
        "체중 감소",
        "소화 불량",
        "식욕 부진",
        "통증(두통, 관절통, 복통 등)",
        "만성 피로"
    ]
    private var optionButtons: [UIButton] = []
    private var selectedOptions: Set<String> = []

    // 자동완성 결과 저장
    private var searchResults: [String] = []
    private var isStepTwo = false // ✅ 현재 상태 관리 (1단계/2단계)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupActions()
        setupTableView()
        setupSearchContainer() // ✅ 검색창 기본 생성
        fetchUserName()
        updateUI(forStepTwo: false)
    }

    // MARK: - UI Layout
    private func setupLayout() {
        view.addSubview(mainStackView)
        view.addSubview(previousButton)
        view.addSubview(nextButton)
        view.addSubview(tableView)

        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(searchContainer)
        mainStackView.addArrangedSubview(addButton)

        mainStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(mainStackView)
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
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DiseaseCell")
    }

    private func setupSearchContainer() {
        addSearchField() // ✅ 기본 검색창 1개 추가
    }

    // ✅ 검색창 추가 함수
    @objc private func addSearchField() {
        let newSearchField = UITextField().then {
            $0.placeholder = "질병 검색하기"
            $0.borderStyle = .roundedRect
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }

        searchFields.append(newSearchField)
        searchContainer.addArrangedSubview(newSearchField)
    }

    // ✅ Step 2 UI 업데이트
    private func updateUI(forStepTwo: Bool, userName: String = "000") {
        isStepTwo = forStepTwo

        if forStepTwo {
            titleLabel.text = "질병으로 인해 겪는 건강 상의 불편함은 무엇인가요?"
            subtitleLabel.text = "(중복 허용)"
            searchContainer.isHidden = true
            tableView.isHidden = true
            addButton.isHidden = true

            // ✅ 기존 옵션 버튼 제거 후 다시 추가
            optionButtons.forEach { $0.removeFromSuperview() }
            optionButtons.removeAll()

            // ✅ Step 2 옵션 버튼 추가
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
        } else {
            titleLabel.text = "\(userName) 님의 질병은 무엇입니까?"
            searchContainer.isHidden = false
            tableView.isHidden = searchResults.isEmpty
            addButton.isHidden = false

            // ✅ Step 2에서 추가된 옵션 버튼들 제거
            optionButtons.forEach { $0.removeFromSuperview() }
            optionButtons.removeAll()
        }
    }
    
    private func fetchUserName() {
        nameService.fetchUserName { [weak self] name in
            guard let self = self else { return }
            self.updateUI(forStepTwo: false, userName: name)
        }
    }


    @objc private func previousButtonTapped() {
        updateUI(forStepTwo: false)
    }

    @objc private func nextButtonTapped() {
        if isStepTwo {
            // ✅ Step 2에서는 선택된 옵션을 서버에 전송하고 다음 화면으로 이동
            sendSelectedOptions()
        } else {
            // ✅ Step 1에서는 UI 업데이트 및 질병 정보 PATCH
            updateUI(forStepTwo: true)
            updateDiseases()
        }
    }


    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let query = textField.text, !query.isEmpty else {
            searchResults = []
            tableView.isHidden = true
            tableView.reloadData()
            return
        }

        provider.request(.searchDisease(keyword: query)) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    self.searchResults = (json?["result"] as? [[String: Any]])?.compactMap { $0["name"] as? String } ?? []
                    DispatchQueue.main.async {
                        self.tableView.isHidden = self.searchResults.isEmpty
                        self.tableView.reloadData()
                    }
                } catch {
                    print("JSON Error")
                }
            case .failure(let error):
                print("API Error: \(error)")
            }
        }
    }
    
    @objc private func optionSelected(_ sender: UIButton) {
        let option = sender.currentTitle ?? ""

        if selectedOptions.contains(option) {
            selectedOptions.remove(option)
            sender.backgroundColor = UIColor(hex: "#E8F5E9")
        } else {
            selectedOptions.insert(option)
            sender.backgroundColor = UIColor(hex: "#009459")
        }
    }


    func updateDiseases() {
        let selectedDiseases = searchFields.compactMap { $0.text }.filter { !$0.isEmpty }

        for disease in selectedDiseases {
            provider.request(.updateDisease(diseaseName: disease)) { _ in }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiseaseCell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    private func sendSelectedOptions() {
        let selectedArray = Array(selectedOptions)
        
        // ✅ 선택된 옵션이 없으면 실행하지 않음
        guard !selectedArray.isEmpty else {
            print("❌ 선택된 옵션이 없습니다. '다음' 버튼이 비활성화됩니다.")
            return
        }
        
        questionService.sendSelectedOptions(selectedOptions: selectedArray) { success in
            DispatchQueue.main.async {
                if success {
                    print("✅ 선택된 옵션 전송 성공: \(selectedArray)")
                    
                    self.navigateToNeedQuestions()
                    
                } else {
                    print("❌ 선택된 옵션 전송 실패")
                }
            }
        }
    }
    
    private func navigateToNeedQuestions() {
        let needQuestionVC = NeedDietVC() // ✅ NeedQuestion 화면으로 이동
        needQuestionVC.modalPresentationStyle = .fullScreen
        self.present(needQuestionVC, animated: true, completion: nil)
    }



}
