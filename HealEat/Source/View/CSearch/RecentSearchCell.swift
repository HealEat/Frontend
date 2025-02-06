// Copyright © 2025 HealEat. All rights reserved.


import UIKit

class RecentSearchCell: UITableViewCell {
    
    static let identifier = "RecentSearchCell"
        
    public lazy var cellLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .light)
        $0.textColor = UIColor.healeatGray5
    }
    
    public lazy var typeImage = UIImageView().then {
        $0.tintColor = UIColor.healeatGray4
    }
    
    private lazy var deleteButton = UIButton().then {
        let image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = UIColor.healeatGray5
    }
    
    
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
        contentView.addSubview(typeImage)
        contentView.addSubview(deleteButton)
        contentView.backgroundColor = .white
        backgroundColor = .clear
        
        
        cellLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(typeImage.snp.trailing).offset(15)
        }
        typeImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(18)
        }
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
            make.width.height.equalTo(18)
        }
        
    }
}
