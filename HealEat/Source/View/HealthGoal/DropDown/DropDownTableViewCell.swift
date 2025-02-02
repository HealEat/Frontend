// Copyright © 2025 HealEat. All rights reserved.


import UIKit

class DropDownTableViewCell: UITableViewCell {
    
    static let identifier = "DropDownTableViewCell"
        
    public let cellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = UIColor(hex: "#797979")
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        cellLabel.text = "\(text)"
    }
    
    
    func setUpUI() {
        contentView.addSubview(cellLabel)
        contentView.backgroundColor = .white
        backgroundColor = .clear
        
        
        cellLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
}
