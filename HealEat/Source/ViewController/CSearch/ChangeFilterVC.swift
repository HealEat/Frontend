// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SwiftyToaster

class ChangeFilterVC: UIViewController {
    private let foodTypeList = FoodCategory.allItems
    private let nutritionList = NutritionCategory.allItems
    private let maxSelectionCount = 5
    private var selectedRating: Float = 0.0
    
    weak var delegate: ChangeFilterVCDelegate?
        
    
    // MARK: - UI Components
    private lazy var vcLabel = UILabel().then {
        $0.textColor = UIColor.healeatGray5
        $0.text = "필터"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    private lazy var keywordBackground = KeywordChipsView().then {
        $0.backgroundColor = .white
        $0.allKeywordButton.addTarget(self, action: #selector(showKeywords), for: .touchUpInside)
        $0.label.textColor = .black
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
        $0.setTitle("+\(foodTypeList.count)", for: .normal)
        $0.setTitleColor(UIColor.healeatGreen1, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.backgroundColor = .healeatLightGreen
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    private lazy var nutritionButton =  UIButton().then {
        $0.setTitle("+\(nutritionList.count)", for: .normal)
        $0.setTitleColor(UIColor.healeatGreen1, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.backgroundColor = .healeatLightGreen
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private lazy var openHoursLabel = UILabel().then {
        $0.text = "영업 시간"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    private lazy var leastRatingLabel = UILabel().then {
        $0.text = "최소 별점"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    private lazy var openNowButton = FilterButton(title: "영업 중")
    private lazy var open24HoursButton = FilterButton(title: "24시간 영업")
    private lazy var over3P5Button = FilterButton(title: "3.5 이상")
    private lazy var over4Button = FilterButton(title: "4.0 이상")
    private lazy var over4P5Button = FilterButton(title: "4.5 이상")
    
    private lazy var openHoursStack = UIStackView(arrangedSubviews: [openNowButton, open24HoursButton]).then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 10
    }
    private lazy var leastRatingStack = UIStackView(arrangedSubviews: [over3P5Button, over4Button, over4P5Button]).then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 10
    }
    private lazy var resetButton = UIButton().then {
        let string = NSAttributedString(string: "초기화", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.healeatGray5
        ])
        $0.setAttributedTitle(string, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor.healeatGray5.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .healeatGray2
    }
    private lazy var applyFilterButton = UIButton().then {
        let string = NSAttributedString(string: "적용", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.healeatGreen1
        ])
        $0.setAttributedTitle(string, for: .normal)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 14
        $0.layer.borderColor = UIColor.healeatGreen1.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .healeatLightGreen
    }
    private lazy var bottomButtonStack = UIStackView(arrangedSubviews: [resetButton, applyFilterButton]).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 15
        
    }
    

        

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        over3P5Button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        over4Button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        over4P5Button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        
        resetButton.addTarget(self, action: #selector(resetFilters), for: .touchUpInside)
        applyFilterButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
    }
    

    @objc private func filterButtonTapped(_ sender: FilterButton) {
        let allButtons = [over3P5Button, over4Button, over4P5Button]

        if sender.isSelectedState {
            // ✅ 이미 선택된 버튼을 다시 누르면 선택 해제
            sender.isSelectedState = false
            selectedRating = 0.0
        } else {
            // ✅ 모든 버튼 비활성화 후 선택된 버튼만 활성화
            allButtons.forEach { $0.isSelectedState = false }
            sender.isSelectedState = true

            // ✅ 선택된 값 저장
            switch sender {
            case over3P5Button:
                selectedRating = 3.5
            case over4Button:
                selectedRating = 4.0
            case over4P5Button:
                selectedRating = 4.5
            default:
                selectedRating = 0.0
            }
        }
    }


    


    // MARK: - UI Methods
    private func setupUI() {
        view.backgroundColor = .white
        
        [vcLabel, keywordBackground, leastRatingLabel, leastRatingStack, bottomButtonStack].forEach {
            view.addSubview($0)
        }
        [foodTypeCollectionView, nutritionCollectionView, foodTypeButton, nutritionButton].forEach {
            keywordBackground.addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        vcLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        keywordBackground.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(vcLabel.snp.bottom).offset(10)
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
        leastRatingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(keywordBackground.snp.bottom).offset(15)
        }
        leastRatingStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(leastRatingLabel.snp.bottom).offset(15)
        }
        bottomButtonStack.snp.makeConstraints { make in
            make.top.equalTo(leastRatingStack.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(15)
            make.height.equalTo(42)
        }
        
    }
    
    //MARK: Setup Actions
    @objc private func showKeywords() {
        let keywordVC = AllKeywordsVC()
        navigationController?.pushViewController(keywordVC, animated: true)
    }
    
    @objc private func applyFilters() {
        let foodList = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 0))
        let nutritionList = Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 1))
        let x = LocationManager.shared.currentLongitude
        let y = LocationManager.shared.currentLatitude
        let searchBy = SortSelectionManager.shared.searchBy
        let sortBy = SortSelectionManager.shared.sortBy
        
        SearchRequestManager.shared.updateFilters(
            x: "\(x)",
            y: "\(y)",
            categoryIdList: foodList,
            featureIdList: nutritionList,
            minRating: selectedRating,
            searchBy: searchBy,
            sortBy: sortBy
        )
        
        search()
    }
    
    @objc private func resetFilters() {
        CategorySelectionManager.shared.clearAllSelections()
        let x = LocationManager.shared.currentLongitude
        let y = LocationManager.shared.currentLatitude
        SortSelectionManager.shared.searchBy = .accuracy
        SortSelectionManager.shared.sortBy = .rating
        
        SearchRequestManager.shared.updateFilters(
            query: "",
            x: "\(x)",
            y: "\(y)",
            categoryIdList: [],
            featureIdList: [],
            minRating: 0.0,
            searchBy: .accuracy,
            sortBy: .rating
        )
        
        search()
    }
    
    //MARK: API call
    private func search() {
        let param = SearchRequestManager.shared.currentRequest

        CSearchManager.search(page: 1, param: param) { isSuccess, searchResults in
            guard isSuccess, let searchResults = searchResults else {
                Toaster.shared.makeToast("검색 요청 실패")
                return
            }
            
            self.delegate?.didReceiveSearchResults(searchResults)
            self.dismiss(animated: true)
        }
    }

}


extension ChangeFilterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView.tag == 0 ? foodTypeList.count : nutritionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodKeywordCell.identifier, for: indexPath) as! FoodKeywordCell

        let categoryType = collectionView.tag
        let item = (categoryType == 0) ? foodTypeList[indexPath.row].name : nutritionList[indexPath.row].name

        let id = (categoryType == 0) ? foodTypeList[indexPath.row].id : nutritionList[indexPath.row].id
        
        cell.label.text = item

        let isSelected = CategorySelectionManager.shared.getSelectedItems(forCategory: categoryType).contains(id)
        cell.updateUI(isSelected: isSelected)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryType = collectionView.tag

        let id = (categoryType == 0) ? foodTypeList[indexPath.row].id : nutritionList[indexPath.row].id

        if CategorySelectionManager.shared.getSelectedItems(forCategory: categoryType).contains(id) {
            CategorySelectionManager.shared.removeSelection(id, forCategory: categoryType)
        } else {
            if CategorySelectionManager.shared.getTotalSelectedCount() >= maxSelectionCount {
                Toaster.shared.makeToast("5개 이상 선택할 수 없습니다.", .short)
                return
            }
            CategorySelectionManager.shared.addSelection(id, forCategory: categoryType)
        }
        collectionView.reloadItems(at: [indexPath])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = (collectionView.tag == 0) ? foodTypeList[indexPath.item].name : nutritionList[indexPath.item].name

        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.text = item
        label.sizeToFit()

        return CGSize(width: label.frame.width + 13, height: label.frame.height + 7)
    }
}


protocol ChangeFilterVCDelegate: AnyObject {
    func didReceiveSearchResults(_ results: HomeResponse)
}
