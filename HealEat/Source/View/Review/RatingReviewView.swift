// Copyright © 2025 HealEat. All rights reserved.

import UIKit

enum ReviewFieldEnum: CaseIterable {
    case taste
    case clean
    case fresh
    case nutrition
    
    var title: String {
        switch self {
        case .taste:
            return "맛"
        case .clean:
            return "청결도"
        case .fresh:
            return "신선도"
        case .nutrition:
            return "영양 균형"
        }
    }
}

class RatingReviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var totalReviewView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var reviewStarsView: StarsView = {
        let starsView = StarsView(accentColor: .healeatGreen2, baseColor: .healeatGray4)
        starsView.isUserInteractionEnabled = false
        return starsView
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .healeatGray5
        return label
    }()
    
    lazy var fieldReviewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var tasteReviewView: FieldReviewView = {
        let fieldReviewView = FieldReviewView(field: .taste)
        return fieldReviewView
    }()
    
    lazy var cleanReviewView: FieldReviewView = {
        let fieldReviewView = FieldReviewView(field: .clean)
        return fieldReviewView
    }()
    
    lazy var freshReviewView: FieldReviewView = {
        let fieldReviewView = FieldReviewView(field: .fresh)
        return fieldReviewView
    }()
    
    lazy var nutritionReviewView: FieldReviewView = {
        let fieldReviewView = FieldReviewView(field: .nutrition)
        return fieldReviewView
    }()
    
    func initializeView(totalScore: Float, totalCount: Int, tasteScore: Float, cleanScore: Float, freshScore: Float, nutritionScore: Float) {
        reviewStarsView.star = totalScore
        reviewLabel.text = "\(totalScore) (\(totalCount))"
        tasteReviewView.reviewBar.drawProcess(process: CGFloat(tasteScore) / CGFloat(GlobalConst.maxRating))
        cleanReviewView.reviewBar.drawProcess(process: CGFloat(cleanScore) / CGFloat(GlobalConst.maxRating))
        freshReviewView.reviewBar.drawProcess(process: CGFloat(freshScore) / CGFloat(GlobalConst.maxRating))
        nutritionReviewView.reviewBar.drawProcess(process: CGFloat(nutritionScore) / CGFloat(GlobalConst.maxRating))
    }
    
    private func addComponents() {
        self.addSubview(totalReviewView)
        self.addSubview(fieldReviewStackView)
        
        totalReviewView.addSubview(reviewStarsView)
        totalReviewView.addSubview(reviewLabel)
        
        fieldReviewStackView.addArrangedSubview(tasteReviewView)
        fieldReviewStackView.addArrangedSubview(cleanReviewView)
        fieldReviewStackView.addArrangedSubview(freshReviewView)
        fieldReviewStackView.addArrangedSubview(nutritionReviewView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        totalReviewView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(27)
        })
        reviewStarsView.snp.makeConstraints({ make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(6)
        })
        reviewLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(reviewStarsView.snp.trailing).offset(6)
        })
        fieldReviewStackView.snp.makeConstraints({ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(totalReviewView.snp.bottom)
        })
    }
}
