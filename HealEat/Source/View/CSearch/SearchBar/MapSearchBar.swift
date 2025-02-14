// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SnapKit
import Then

class MapSearchBar: UIView, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var returnKeyPressed: ((String?) -> Void)? // 텍스트 변경 시 호출될 클로저
    
    private lazy var background = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = false
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.layer.shadowRadius = 8
    }
    
    lazy var searchBar = UITextField().then {
        $0.backgroundColor = .white
        $0.borderStyle = .none
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = UIColor.healeatGray5
    }


        
    private lazy var image = UIImageView().then {
        let config = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = UIColor.black
    }
    private lazy var mike = UIImageView().then {
        let config = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(systemName: "microphone",withConfiguration: config )?.withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = UIColor.black
    }
    public lazy var dismissButton = UIButton().then {
        $0.tintColor = .black
        let config = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(systemName: "lessthan", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        $0.setBackgroundImage(image, for: .normal)
        $0.imageView?.contentMode = .scaleToFill
        $0.clipsToBounds = true
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        
        searchBar.delegate = self
        searchBar.returnKeyType = .search
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        self.addSubview(background)
        background.addSubview(searchBar)
        background.addSubview(dismissButton)
        background.addSubview(image)
        background.addSubview(mike)
        setupConstraints()
    }
    
    private func setupConstraints() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        dismissButton.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(27)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        image.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.leading.equalTo(dismissButton.snp.trailing).offset(10)
        }
        searchBar.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.trailing.equalTo(mike.snp.leading).offset(-5)
        }
        mike.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    
    // MARK: - Action Function
    func textFieldShouldReturn(_ textfield: UITextField) -> Bool {
        returnKeyPressed?(textfield.text)  // 클로저 실행
        textfield.resignFirstResponder()   // 키보드 내리기
        return true
    }
}
