// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class StoreInfoTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var locationView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .subtract).withTintColor(.healeatGray4, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .healeatGray5
        return label
    }()
    
    lazy var phoneView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var phoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "phone.fill")?.withTintColor(.healeatGray4, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .healeatGray5
        return label
    }()
    
    lazy var linkView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var linkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .link).withTintColor(.healeatGray4, renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var linkButton: UIButton = {
        let button = UIButton()
        button.setTitle("매장 정보 자세히 보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.healeatGray5, for: .normal)
        return button
    }()
    
    private func addComponents() {
        contentView.addSubview(infoStackView)
        
        infoStackView.addArrangedSubview(locationView)
        infoStackView.addArrangedSubview(phoneView)
        infoStackView.addArrangedSubview(linkView)
        
        locationView.addSubview(locationImageView)
        locationView.addSubview(locationLabel)
        
        phoneView.addSubview(phoneImageView)
        phoneView.addSubview(phoneLabel)
        
        linkView.addSubview(linkImageView)
        linkView.addSubview(linkButton)
        
        setConstraints()
    }
    
    private func setConstraints() {
        infoStackView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
        })
        locationImageView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(18)
        })
        locationLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(locationImageView.snp.trailing).offset(10)
        })
        phoneImageView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(18)
        })
        phoneLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(phoneImageView.snp.trailing).offset(10)
        })
        linkImageView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(18)
        })
        linkButton.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(linkImageView.snp.trailing).offset(10)
        })
    }
}
