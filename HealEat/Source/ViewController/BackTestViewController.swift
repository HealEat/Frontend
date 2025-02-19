// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class BackTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(placeId)
        self.view.addSubview(memberId)
        self.view.addSubview(button)
        
        titleLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(64)
            make.centerX.equalToSuperview()
        })
        placeId.snp.makeConstraints({ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        })
        memberId.snp.makeConstraints({ make in
            make.top.equalTo(placeId.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        })
        button.snp.makeConstraints({ make in
            make.top.equalTo(memberId.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        })
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "백엔드 테스트를 위한 임시화면입니다."
        return label
    }()
    
    lazy var placeId: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "placeId"
        return textField
    }()
    
    lazy var memberId: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1
        textField.placeholder = "memberId"
        return textField
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("마켓 뷰로 가기", for: .normal)
        button.addTarget(self, action: #selector(onClickButton), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    @objc private func onClickButton() {
        let marketVC = MarketVC()
        marketVC.param = MarketVC.Param(placeId: Int(placeId.text!)!)
        GlobalConst.memberId = Int(memberId.text!)!
        navigationController?.pushViewController(marketVC, animated: true)
    }
}
