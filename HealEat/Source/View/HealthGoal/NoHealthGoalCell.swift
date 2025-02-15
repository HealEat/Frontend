// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SDWebImage

final class NoHealthGoalCell: UICollectionViewCell {
     
    static let identifier = "NoHealthGoalCell"
    
    
    // MARK: - UI Properties
    private lazy var label = UILabel().then {
        $0.text = "등록된 건강 관리 목표가 없습니다."
        $0.textColor = UIColor(hex: "656565")
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    
    // MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpConstraints()
    }
            
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    
    // MARK: - UI Methods
    private func setUpConstraints() {
        addSubview(label)
                
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
    }
    
}

