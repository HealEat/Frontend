// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class RatingReviewTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var ratingReviewView: RatingReviewView = {
        let view = RatingReviewView()
        return view
    }()
    
    private func addComponents() {
        contentView.addSubview(ratingReviewView)
        setConstraints()
    }
    
    private func setConstraints() {
        ratingReviewView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview()
        })
    }
}
