// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class DropDownButton: UIButton {
    
    private let myImageView = UIImageView().then {
        $0.isUserInteractionEnabled = false
        let image = UIImage(systemName:"chevron.down")?.withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = .healeatGray5
        $0.contentMode = .scaleAspectFit
        $0.isOpaque = false
    }
    
    let label = UILabel().then {
        $0.textColor = .healeatGray5
        $0.font = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    init() {
        super.init(frame: .zero)
        setUp()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
        
    private func setUp() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.masksToBounds = true
        layer.borderColor = UIColor.healeatGray4.cgColor
        layer.borderWidth = 1
        
        [label, myImageView].forEach {
            addSubview($0)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        
        
        myImageView.snp.makeConstraints { make in
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-11)
        }
    }
}
