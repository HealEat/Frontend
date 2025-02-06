// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SnapKit
import Then

class CustomSearchBar: UIView {
    
    // MARK: - Properties
    
    var onTextDidChange: ((String) -> Void)? // 텍스트 변경 시 호출될 클로저
    
    private lazy var background = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.healeatGray4.cgColor
        $0.layer.borderWidth = 1
    }
    
    lazy var searchBar = UITextField().then {
        $0.backgroundColor = .white
        $0.borderStyle = .none
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = UIColor.healeatGray5
        $0.addLeftPadding()
    }


        
    private lazy var image = UIImageView().then {
        let image = UIImage(named: "magnifyingGlass")?.withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = UIColor.healeatGray4
    }
    private lazy var mike = UIImageView().then {
        let image = UIImage(named: "microphone")?.withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = UIColor.healeatGray4
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
        background.addSubview(image)
        background.addSubview(mike)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        searchBar.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(image.snp.trailing).offset(-5)
            make.trailing.equalTo(mike.snp.leading).offset(-5)
        }
        image.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        mike.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
    }
}
