// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class TabBarSegmentedControl: UIView {
    
    weak var delegate: TabBarSegmentedControlDelegate?
    
    private let menus: [String]
    
    init(menus: [String]) {
        self.menus = menus
        super.init(frame: .zero)
        addButtons()
        addComponents()
        setupUI(selected: 0)
    }
    
    private func addButtons() {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0)
        configuration.baseBackgroundColor = .clear
        for i in 0..<menus.count {
            let button = UIButton()
            button.configuration = configuration
            button.tag = i
            button.addTarget(self, action: #selector(onClickMenu(_:)), for: .touchUpInside)
            button.setAttributedTitle(NSAttributedString(string: menus[i], attributes: [.foregroundColor: UIColor(red: 161/255, green: 161/255, blue: 161/255, alpha: 1), .font: UIFont.systemFont(ofSize: 16)]), for: .normal)
            button.setAttributedTitle(NSAttributedString(string: menus[i], attributes: [.foregroundColor: UIColor.label, .font: UIFont.systemFont(ofSize: 16, weight: .medium)]), for: .selected)
            tabBarStackView.addArrangedSubview(button)
        }
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
    
    private func getSelectedIndex() -> Int? {
        for (index, subview) in tabBarStackView.arrangedSubviews.enumerated() {
            guard let button = subview as? UIButton else { continue }
            if button.isSelected == true {
                return index
            }
        }
        return nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var tabBarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    lazy var selectedArea: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 161/255, green: 161/255, blue: 161/255, alpha: 1)
        return view
    }()
    
    lazy var selectedBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.label
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
        guard let past = getSelectedIndex() else { return }
        let now = sender.tag
        if past == now {
            return
        } else if past < now {
            delegate?.didSelectMenu(direction: .forward, index: sender.tag)
        } else {
            delegate?.didSelectMenu(direction: .reverse, index: sender.tag)
        }
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.setupUI(selected: sender.tag)
            self?.layoutIfNeeded()
        })
    }
}

protocol TabBarSegmentedControlDelegate: AnyObject {
    func didSelectMenu(direction: UIPageViewController.NavigationDirection, index: Int)
}
