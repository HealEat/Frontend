// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import CHTCollectionViewWaterfallLayout

class MarketHomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StoreInfoTableViewCell.self, forCellReuseIdentifier: String(describing: StoreInfoTableViewCell.self))
        tableView.register(WriteReviewTableViewCell.self, forCellReuseIdentifier: String(describing: WriteReviewTableViewCell.self))
        tableView.register(RatingReviewTableViewCell.self, forCellReuseIdentifier: String(describing: RatingReviewTableViewCell.self))
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: String(describing: ImageTableViewCell.self))
        tableView.allowsSelection = false
        tableView.separatorColor = .healeatGray3P5
        tableView.separatorInset = .zero
        tableView.sectionHeaderTopPadding = 0
        tableView.sectionFooterHeight = 0
        tableView.bouncesVertically = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private func addComponents() {
        self.addSubview(mainTableView)
        setConstraints()
    }
    
    private func setConstraints() {
        mainTableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}
