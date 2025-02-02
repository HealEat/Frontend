// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class DropDownButton: UIButton {
    
    private let myImageView = UIImageView().then {
        $0.isUserInteractionEnabled = false
        $0.image = UIImage(named: "dropDownArrow")
    }
    
    let label = UILabel().then {
        $0.textColor = UIColor(hex: "#797979")
        $0.font = UIFont.systemFont(ofSize: 10, weight: .medium)
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
        layer.cornerRadius = 12
        clipsToBounds = true
        layer.borderColor = UIColor(hex: "#B5B5B5")?.cgColor
        layer.borderWidth = 1
        
        [label, myImageView].forEach(addSubview(_:))
        
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        
        
        myImageView.snp.makeConstraints { make in
            make.width.equalTo(5.97)
            make.height.equalTo(3)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
