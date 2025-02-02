// Copyright © 2025 HealEat. All rights reserved.


import UIKit

class SearchVC: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var searchBar = CustomSearchBar().then {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black.withAlphaComponent(0.5),
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        $0.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "음식, 매장, 주소 검색", attributes: attributes)
    }
        

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    


    // MARK: - UI Methods
    private func setupUI() {
        view.addSubview(searchBar)
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    //MARK: Setup Actions
    
    
    //MARK: API call

}
