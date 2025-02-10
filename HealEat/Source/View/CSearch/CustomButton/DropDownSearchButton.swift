// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class DropDownSearchButton: UIButton {
    
    private lazy var myImageView = UIImageView().then {
        $0.isUserInteractionEnabled = false
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "chevron.down", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = false
        $0.image = image
        $0.tintColor = UIColor.healeatGray6
    }
    
    lazy var buttonLabel = UILabel().then {
        $0.textColor = UIColor.healeatGray6
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    private lazy var stack = UIStackView(arrangedSubviews: [buttonLabel, myImageView]).then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 3
        $0.alignment = .center
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
        addSubview(stack)
        myImageView.snp.makeConstraints { make in
            make.width.equalTo(8)
            make.height.equalTo(3)
        }
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
