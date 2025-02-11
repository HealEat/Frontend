// Copyright © 2025 HealEat. All rights reserved.


import UIKit

class SearchVC: UIViewController {
    let foodTypeList = FoodCategory.allItems
    let nutritionList = NutritionCategory.allItems
    var recentSearches: [RecentSearchItem] = []
        
    
    // MARK: - UI Components
    private lazy var searchBar = CustomSearchBar().then {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.healeatGray5,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        $0.searchBar.attributedPlaceholder = NSAttributedString(string: "음식, 매장, 주소 검색", attributes: attributes)
    }
    
    private lazy var keywordBackground = KeywordChipsView().then {
        $0.backgroundColor = .white
        $0.allKeywordButton.addTarget(self, action: #selector(showKeywords), for: .touchUpInside)
    }
    
    private lazy var foodTypeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 3
        $0.minimumInteritemSpacing = 6
    })).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(FoodKeywordCell.self, forCellWithReuseIdentifier: FoodKeywordCell.identifier)
        $0.dataSource = self
        $0.delegate = self
        $0.tag = 0
    }

    private lazy var nutritionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then({
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 3
        $0.minimumInteritemSpacing = 6
    })).then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(FoodKeywordCell.self, forCellWithReuseIdentifier: FoodKeywordCell.identifier)
        $0.dataSource = self
        $0.delegate = self
        $0.tag = 1
    }
    private lazy var foodTypeButton =  UIButton().then {
        $0.setTitle("+15", for: .normal)
        $0.setTitleColor(UIColor.healeatGreen1, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.backgroundColor = .healeatLightGreen
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    private lazy var nutritionButton =  UIButton().then {
        $0.setTitle("+12", for: .normal)
        $0.setTitleColor(UIColor.healeatGreen1, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.backgroundColor = .healeatLightGreen
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(goToFilteredSearch), for: .touchUpInside)
    }
    private lazy var tableview = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .white
        $0.separatorColor = UIColor(hex: "EBEBEB")
        $0.separatorInset = .zero
        $0.separatorStyle = .singleLine
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "headerCell") // ✅ 기본 셀 등록
        $0.register(RecentSearchCell.self, forCellReuseIdentifier: RecentSearchCell.identifier)
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
        

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecentSearches()
    }
    


    // MARK: - UI Methods
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(keywordBackground)
        keywordBackground.addSubview(foodTypeCollectionView)
        keywordBackground.addSubview(nutritionCollectionView)
        keywordBackground.addSubview(foodTypeButton)
        keywordBackground.addSubview(nutritionButton)
        view.addSubview(tableview)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.height.equalTo(50)
        }
        keywordBackground.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.height.equalTo(150)
        }
        foodTypeCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(70)
            make.trailing.equalToSuperview().offset(-60)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        nutritionCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(70)
            make.trailing.equalToSuperview().offset(-60)
            make.centerY.equalTo(foodTypeCollectionView.snp.bottom).offset(30)
            make.height.equalTo(24)
        }
        foodTypeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(37)
            make.height.equalTo(24)
            make.centerY.equalTo(foodTypeCollectionView.snp.centerY)
        }
        nutritionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(37)
            make.height.equalTo(24)
            make.centerY.equalTo(nutritionCollectionView.snp.centerY)
        }
        tableview.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(keywordBackground.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    //MARK: Setup Actions
    @objc private func showKeywords() {
        let keywordVC = AllKeywordsVC()
        navigationController?.pushViewController(keywordVC, animated: true)
    }
    
    @objc private func goToFilteredSearch() {
        let filteredSearchVC = FilteredSearchVC()
        filteredSearchVC.hidesBottomBarWhenPushed = true // 탭바 숨겨주기
        navigationController?.pushViewController(filteredSearchVC, animated: true)
    }
    
    //MARK: API call
    private func getRecentSearches() {
        CSearchManager.recentSearches(page: 1) { result in
            switch result {
            case .success(let data):
                guard let searchData = data.result?.recentSearchList else { return }
                self.recentSearches = searchData
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
            case .failure(let error):
                print("최근 검색 기록 조회 실패: \(error.localizedDescription)")
            }
        }
    }
    

}


extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return foodTypeList.count
        case 1:
            return nutritionList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodKeywordCell.identifier, for: indexPath) as! FoodKeywordCell
        
        if collectionView.tag == 0 {
            cell.label.text = foodTypeList[indexPath.row]
        } else {
            cell.label.text = nutritionList[indexPath.row]
        }
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize(width: 0, height: 0)
        if collectionView.tag == 0 {
            let label = UILabel().then {
                $0.font = .systemFont(ofSize: 14)
                $0.text = foodTypeList[indexPath.item]
                $0.sizeToFit()
                size = $0.frame.size
            }
        } else {
            let label = UILabel().then {
                $0.font = .systemFont(ofSize: 14)
                $0.text = nutritionList[indexPath.item]
                $0.sizeToFit()
                size = $0.frame.size
            }
        }
        
        return CGSize(width: size.width + 13, height: size.height + 7)
    }
    
    
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentSearches.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
            cell.textLabel?.text = "최근 검색"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            cell.textLabel?.textColor = UIColor.healeatGray5
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchCell.identifier, for: indexPath) as? RecentSearchCell else { return UITableViewCell() }
            let searchData = recentSearches[indexPath.row - 1]
            cell.cellLabel.text = searchData.query
            
            switch searchData.searchType {
            case .store:
                cell.typeImage.image = UIImage(named: "place")
            case .query:
                cell.typeImage.image = UIImage(named: "keyword")
            default:
                cell.typeImage.image = UIImage(systemName: "xmark")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 45
        } else {
            return 35
        }
    }
    
    
}
