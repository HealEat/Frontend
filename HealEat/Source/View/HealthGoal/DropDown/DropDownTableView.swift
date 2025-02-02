// Copyright © 2025 HealEat. All rights reserved.


import UIKit
import SnapKit

class DropDownTableView: UITableView {
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupUI()
        register(DropDownTableViewCell.self, forCellReuseIdentifier: DropDownTableViewCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        register(DropDownTableViewCell.self, forCellReuseIdentifier: DropDownTableViewCell.identifier)
    }
    
    private func setupUI() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.backgroundColor = .clear
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 5
        self.layer.borderColor = UIColor(hex: "#B5B5B5")?.cgColor
        self.layer.borderWidth = 1
    }
    

}
