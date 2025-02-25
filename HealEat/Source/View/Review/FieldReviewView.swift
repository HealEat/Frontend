// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class FieldReviewView: UIView {
    
    var value: Float = 0.0
    
    private let field: ReviewFieldEnum
    
    init(field: ReviewFieldEnum) {
        self.field = field
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = field.title
        label.font = .systemFont(ofSize: 15)
        label.textColor = .healeatBlack
        return label
    }()
    
    lazy var reviewBar: ReviewBar = {
        let view = ReviewBar(field: field)
        view.valueChanged = { [weak self] value in
            self?.value = Float(value) * Float(GlobalConst.maxRating)
            self?.reviewLabel.text = value == 0 ? "-" : (Float(value) * Float(GlobalConst.maxRating)).oneDecimalString
//            self?.reviewLabel.text = (Float(value) * Float(GlobalConst.maxRating)).oneDecimalString
        }
        return view
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .healeatBlack
        return label
    }()
    
    private func addComponents() {
        self.addSubview(titleLabel)
        self.addSubview(reviewBar)
        self.addSubview(reviewLabel)
        setConstraints()
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints({ make in
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(60)
            make.centerY.equalToSuperview()
        })
        reviewBar.snp.makeConstraints({ make in
            make.height.equalTo(30)
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.equalTo(titleLabel.snp.trailing).offset(12)
        })
        reviewLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
            make.leading.equalTo(reviewBar.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        })
    }
    
}
