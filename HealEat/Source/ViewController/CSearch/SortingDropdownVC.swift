// Copyright © 2025 HealEat. All rights reserved.

import UIKit

protocol SortingDropdownDelegate: AnyObject {
    func didSelectSortingOption(_ option: String, isSortBy: Bool)
}

class SortingDropdownVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var sortingOptions: [String] = []
    var selectedOption: String? // ✅ 현재 선택된 값 (UserDefaults에서 불러옴)
    var isSortBy: Bool = true
    
    weak var delegate: SortingDropdownDelegate?
    
    private lazy var tableview = UITableView().then {
        $0.contentInset = .zero
        $0.contentInsetAdjustmentBehavior = .never
        $0.delegate = self
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.register(SortDropdownCell.self, forCellReuseIdentifier: SortDropdownCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 20
        view.layer.masksToBounds = false
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        // ✅ Spread 값을 적용하려면 Shadow Path 설정 필요!
        let spread: CGFloat = 3
        let rect = view.bounds.insetBy(dx: -spread, dy: -spread) // ✅ Spread 값을 적용
        view.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        
        view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview()
        }
        
        preferredContentSize = CGSize(width: 122, height: sortingOptions.count * 30 + 20) // ✅ 작은 크기 지정!
    }
    
    
    // ✅ UserDefaults에 새로운 값 저장
    private func saveSelectedOption(_ option: String) {
        if isSortBy {
            if let sortBy = SortBy.allCases.first(where: { $0.name == option }) {
                SortSelectionManager.shared.sortBy = sortBy
            }
        } else {
            if let searchBy = SearchBy.allCases.first(where: { $0.name == option }) {
                SortSelectionManager.shared.searchBy = searchBy
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SortDropdownCell.identifier, for: indexPath) as? SortDropdownCell else { return UITableViewCell() }
            
        let option = sortingOptions[indexPath.row]
        let isSelected = (option == selectedOption) // ✅ 현재 선택된 값과 비교

        cell.configure(text: option, isSelected: isSelected)
        
        if indexPath.row == sortingOptions.count - 1 {
            cell.separator.isHidden = true
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = sortingOptions[indexPath.row]

        // ✅ UI 업데이트 (선택된 셀 변경)
        self.selectedOption = selectedOption
        tableView.reloadData()
        
        // ✅ UserDefaults에 저장
        saveSelectedOption(selectedOption)
        
        // ✅ Delegate 호출 및 화면 닫기
        delegate?.didSelectSortingOption(selectedOption, isSortBy: isSortBy)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
