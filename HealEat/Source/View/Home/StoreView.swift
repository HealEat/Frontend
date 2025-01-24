//
//  StoreView.swift
//  HealEat
//
//  Created by 이태림 on 1/20/25.
//

import UIKit
import SnapKit
import Then

class StoreView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var userRecommendLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 10, weight: .semibold)
        $0.text = "힐릿님 건강 맞춤 추천"
        let fullText = $0.text ?? ""
        let attribtuedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: "힐릿")
        attribtuedString.addAttribute(.foregroundColor, value: UIColor(red: 0.00, green: 0.58, blue: 0.35, alpha: 1.00), range: range)
        $0.attributedText = attribtuedString
    }
    
    public lazy var healthsettingButton = UIButton().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor(red: 0.51, green: 0.51, blue: 0.51, alpha: 1.00).cgColor
        $0.backgroundColor = .clear
        $0.setTitle("건강 정보 설정하기", for: .normal)
        $0.setTitleColor(.black , for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 8, weight: .regular)
    }
    
    public lazy var storeTableView = UITableView().then {
        $0.register(StoreTableViewCell.self, forCellReuseIdentifier: StoreTableViewCell.identifier)
        $0.separatorStyle = .singleLine
        $0.separatorColor = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.00)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    private func setViews() {
        addSubview(userRecommendLabel)
        addSubview(healthsettingButton)
        addSubview(storeTableView)
    }
    
    private func setConstraints() {
        userRecommendLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(12)
        }
        
        healthsettingButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(27)
            $0.trailing.equalToSuperview().offset(-19)
            $0.height.equalTo(18)
            $0.width.equalTo(80)
        }
        
        storeTableView.snp.makeConstraints {
            $0.top.equalTo(userRecommendLabel.snp.bottom).offset(26)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

}
