// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class FoodKeywordCell: UICollectionViewCell {
    static let identifier = "FoodKeywordCell"
  
  // MARK: - View
  let label = UILabel().then {
      $0.font = .systemFont(ofSize: 12, weight: .regular)
      $0.textColor = UIColor.healeatGray6
  }
  
  // MARK: - layout
  
  override init(frame: CGRect) {
    super.init(frame: frame)
      contentView.layer.cornerRadius = 12
      contentView.layer.masksToBounds = true
      contentView.backgroundColor = UIColor(hex: "F0F0F0") // gray2.5
    
      contentView.addSubview(label)
      setConstraint()
  }
  
  func setConstraint() {
      label.snp.makeConstraints {
          $0.center.equalToSuperview()
      }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
