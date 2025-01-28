





































































































//  CustomSearchBar.swift
//  HealEat
//
//  Created by tokkislove on 1/15/25.
//

import UIKit
import SnapKit
import Then

class CustomSearchBar: UIView {
    
    // MARK: - Properties
    
    var onTextDidChange: ((String) -> Void)? // 텍스트 변경 시 호출될 클로저
    
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.backgroundImage = UIImage()
        bar.barTintColor = .clear
        bar.backgroundColor = .clear
        
        let textField = bar.searchTextField
        textField.backgroundColor = .white
        textField.borderStyle = .none
        textField.layer.cornerRadius = 20
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        textField.layer.borderWidth = 1
        // 🔥 패딩 조절
        /*textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always

        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.rightViewMode = .always*/
               
        return bar
    }()

        
    private lazy var image = UIImageView().then {
        $0.image = UIImage(named: "magnifyingGlass")
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
        self.addSubview(searchBar)
        self.addSubview(image)
        
        // 패딩 제거
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.searchTextField.leftView = nil
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }

        image.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.centerY.equalToSuperview()
            make.leading.equalTo(searchBar.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
        }
    }
}
