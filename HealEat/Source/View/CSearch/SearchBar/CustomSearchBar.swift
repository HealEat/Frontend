// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SnapKit
import Then

class CustomSearchBar: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var returnKeyPressed: ((String?) -> Void)? // 텍스트 변경 시 호출될 클로저
    
    private lazy var background = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    lazy var searchBar = UITextField().then {
        $0.backgroundColor = .white
        $0.borderStyle = .none
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = UIColor.healeatGray5
        $0.addLeftPadding()
        $0.returnKeyType = .search
    }


    public lazy var searchButton = UIButton().then {
        let image = UIImage(named: "magnifyingGlass")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = .black
    }
    private lazy var mikeButton = UIButton().then {
        let image = UIImage(systemName: "microphone")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = .black
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.addSubview(background)
        background.addSubview(searchBar)
        background.addSubview(searchButton)
        background.addSubview(mikeButton)
        
        setupConstraints()
        self.searchBar.delegate = self
    }
    
    private func setupConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(45)
        }
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        searchBar.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(searchButton.snp.leading).offset(6)
            make.trailing.equalTo(mikeButton.snp.leading).offset(-6)
        }
        mikeButton.snp.makeConstraints { make in
            make.width.equalTo(23)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: - Action Function
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        returnKeyPressed?(textfield.text)  // 클로저 실행
        textfield.resignFirstResponder()   // 키보드 내리기
        return true
    }
    
    
}
