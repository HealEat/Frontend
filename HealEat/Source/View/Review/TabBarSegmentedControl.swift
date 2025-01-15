//
//  TabBarSegmentedControl.swift
//  HealEat
//
//  Created by 김호성 on 2025.01.15.
//

import UIKit
import SnapKit

class TabBarSegmentedControl: UIView {
    
    weak var delegate: TabBarSegmentedControlDelegate?
    
    private let menus: [String]
    
    init(menus: [String]) {
        self.menus = menus
        super.init(frame: .zero)
        
        for i in 0..<menus.count {
            let button = UIButton()
            button.tag = i
            button.addTarget(self, action: #selector(onClickMenu(_:)), for: .touchUpInside)
            button.setAttributedTitle(NSAttributedString(string: menus[i], attributes: [.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)]), for: .normal)
            button.setAttributedTitle(NSAttributedString(string: menus[i], attributes: [.foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1)]), for: .selected)
            
            tabBarStackView.addArrangedSubview(button)
        }
        addComponents()
        setupUI(selected: 0)
    }
    
    private func setupUI(selected: Int) {
        tabBarStackView.arrangedSubviews.forEach({
            guard let button = $0 as? UIButton else { return }
            button.isSelected = false
        })
        guard let button = tabBarStackView.arrangedSubviews[selected] as? UIButton else { return }
        button.isSelected = true
        
        updateSelectedBarConstraints(index: selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tabBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var selectedArea: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    
    lazy var selectedBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    private func addComponents() {
        self.addSubview(tabBarStackView)
        self.addSubview(selectedArea)
        selectedArea.addSubview(selectedBar)
        setConstraints()
    }
    private func setConstraints() {
        tabBarStackView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
        })
        selectedArea.snp.makeConstraints({ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(tabBarStackView.snp.bottom)
            make.height.equalTo(1)
        })
    }
    
    func updateSelectedBarConstraints(index: Int) {
        selectedBar.snp.remakeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(tabBarStackView.arrangedSubviews[index].snp.leading)
            make.trailing.equalTo(tabBarStackView.arrangedSubviews[index].snp.trailing)
        })
    }
    
    @objc func onClickMenu(_ sender: UIButton) {
        delegate?.didSelectMenu(index: sender.tag)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.setupUI(selected: sender.tag)
            self?.layoutIfNeeded()
        })
    }
}

protocol TabBarSegmentedControlDelegate: AnyObject {
    func didSelectMenu(index: Int)
}