// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SwiftyToaster

class AllKeywordsVC: UIViewController {
    public var isFoodType = true
    private let maxSelectionCount = 5
    private var isProcessing = false
        
    // MARK: - UI Components
    private lazy var customBackButton = UIButton().then {
        let image = UIImage(systemName: "lessthan")?.withRenderingMode(.alwaysTemplate)
        $0.setBackgroundImage(image, for: .normal)
        $0.tintColor = UIColor.healeatGray4
        $0.imageView?.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    }
    private lazy var searchBar = CustomCSearchBar().then {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.healeatGray5,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        $0.searchBar.attributedPlaceholder = NSAttributedString(string: "음식, 매장, 주소 검색", attributes: attributes)
        $0.searchBar.text = SearchRequestManager.shared.query
        
        $0.returnKeyPressed = { text in
            guard !self.isProcessing else { return }
            self.isProcessing = true
            self.searchButtonClicked()
        }
    }

    private lazy var allKeywordsView = AllKeywordChipsView().then {
        $0.backgroundColor = .white
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Methods
    private func setupUI() {
        view.backgroundColor = .white
        [customBackButton, searchBar, allKeywordsView].forEach {
            view.addSubview($0)
        }
        
        setupConstraints()
        hideKeyboardWhenTappedAround()
        setInteractivePopGesture()
        allKeywordsView.isFoodType = isFoodType
        searchBar.searchButton.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        customBackButton.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(38)
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalTo(searchBar.snp.centerY)
        }
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(customBackButton.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.height.equalTo(50)
        }
        allKeywordsView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setInteractivePopGesture() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: Setup Actions
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    private func goToFilteredSearch(searchResults: HomeResponse) {
        hideLoadingIndicator()
        let filteredSearchVC = FilteredSearchVC()
        filteredSearchVC.filteredStoresVC.filteredData = searchResults
        filteredSearchVC.filteredStoresVC.storeData = searchResults.storeList
        filteredSearchVC.avgX = searchResults.searchInfo?.avgX
        filteredSearchVC.avgY = searchResults.searchInfo?.avgY
        filteredSearchVC.hidesBottomBarWhenPushed = true // 탭바 숨겨주기
        isProcessing = false
        navigationController?.pushViewController(filteredSearchVC, animated: true)
    }
    
    private func getSearchFilters() -> (query: String, x: String, y: String, foodList: [Int], nutritionList: [Int], searchBy: SearchBy, sortBy: SortBy) {
        return (
            query: searchBar.searchBar.text ?? "",
            x: "\(LocationManager.shared.currentLongitude)",
            y: "\(LocationManager.shared.currentLatitude)",
            foodList: Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 0)),
            nutritionList: Array(CategorySelectionManager.shared.getSelectedItems(forCategory: 1)),
            searchBy: SortSelectionManager.shared.searchBy,
            sortBy: SortSelectionManager.shared.sortBy
        )
    }
    
    @objc private func searchButtonClicked() {
        showLoadingIndicator()
        let filters = getSearchFilters()
        SearchRequestManager.shared.updateFilters(
            query: filters.query,
            x: filters.x,
            y: filters.y,
            categoryIdList: filters.foodList,
            featureIdList: filters.nutritionList,
            minRating: 0.0,
            searchBy: filters.searchBy,
            sortBy: filters.sortBy
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
            
            self.goToFilteredSearch(searchResults: searchResults)
        }
    }

}

extension AllKeywordsVC: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.navigationController?.viewControllers.count ?? 0 > 1
    }
}

