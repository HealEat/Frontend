// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit
import Then

class FoodTagCell: UICollectionViewCell {
    static let identifier = "FoodTagCell"
  
  // MARK: - View
  let label = UILabel().then {
      $0.font = .systemFont(ofSize: 12, weight: .regular)
      $0.textColor = UIColor(hex: "5A5A5A")
  }
  
  // MARK: - layout
  
  override init(frame: CGRect) {
    super.init(frame: frame)
      contentView.layer.cornerRadius = 12
      contentView.layer.borderWidth = 0.7
      contentView.layer.borderColor = UIColor(hex: "CFCFCF")?.cgColor
      contentView.backgroundColor = UIColor(hex: "F8F8F8")
    
      contentView.addSubview(label)
      setConstraint()
  }
  
  func setConstraint() {
      label.snp.makeConstraints {
          $0.leading.trailing.equalToSuperview().inset(8)
          $0.top.bottom.equalToSuperview().inset(3)
      }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
