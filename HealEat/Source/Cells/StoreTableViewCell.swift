//
//  StoreTableViewCell.swift
//  HealEat
//
//  Created by 이태림 on 1/23/25.
//

import UIKit
import SnapKit
import Then

class StoreTableViewCell: UITableViewCell {

    static let identifier = "SavedCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setViews()
        self.setConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.storename.text = nil
        self.storeaddress.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var storename = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .black
    }
    
    private lazy var storeaddress = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 8, weight: .semibold)
        $0.textColor = .black
    }
    
    private func setViews() {
        addSubview(storename)
        addSubview(storeaddress)
    }
    
    private func setConstraints() {
        storename.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview()
            $0.height.equalTo(18)
        }
        
        storeaddress.snp.makeConstraints {
            $0.top.equalTo(storename.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.height.equalTo(15)
        }
    }
    
    public func configure(model: StoreModel) {
        self.storename.text = model.storename
        self.storeaddress.text = model.storeaddress
    }
    
}
