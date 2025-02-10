// Copyright © 2025 HealEat. All rights reserved.


import UIKit

class ChangeFilterVC: UIViewController {
    let foodTypeList = FoodCategory.allItems
    let nutritionList = NutritionCategory.allItems
    let recentSearches = [
        RecentSearchModels(type: "place", nameData: "샐러디"),
        RecentSearchModels(type: "keyword", nameData: "포케"),
        RecentSearchModels(type: "place", nameData: "내가 찜한 닭"),
        RecentSearchModels(type: "place", nameData: "본죽")
    ]
        
    
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

    }
    


    // MARK: - UI Methods
    private func setupUI() {
        view.backgroundColor = .white
        
        [vcLabel, keywordBackground, openHoursLabel, openHoursStack, leastRatingLabel, leastRatingStack, bottomButtonStack].forEach {
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
        openHoursLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(keywordBackground.snp.bottom).offset(15)
        }
        openHoursStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(openHoursLabel.snp.bottom).offset(15)
        }
        leastRatingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(openHoursStack.snp.bottom).offset(15)
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
    
    //MARK: API call

}


extension ChangeFilterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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


