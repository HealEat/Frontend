//
//  WriteReviewView.swift
//  HealEat
//
//  Created by 김호성 on 2025.01.14.
//

import UIKit
import SnapKit

class WriteReviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var reviewBar: ReviewBar = {
        let view = ReviewBar()
        view.valueChanged = { [weak self] value in
            self?.reviewLabel.text = "\(String(format: "%.1f", value * 5))"
        }
        return view
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private func addComponents() {
        self.addSubview(reviewBar)
        self.addSubview(reviewLabel)
        setConstraints()
    }
    func setConstraints() {
        reviewBar.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
        })
        reviewLabel.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(reviewBar.snp.bottom).offset(32)
        })
    }
}
