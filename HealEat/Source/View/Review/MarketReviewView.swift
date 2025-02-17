// Copyright © 2025 HealEat. All rights reserved.

import UIKit

class MarketReviewView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var reviewTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WriteReviewTableViewCell.self, forCellReuseIdentifier: String(describing: WriteReviewTableViewCell.self))
        tableView.register(RatingReviewTableViewCell.self, forCellReuseIdentifier: String(describing: RatingReviewTableViewCell.self))
        tableView.register(NoReviewTableViewCell.self, forCellReuseIdentifier: String(describing: NoReviewTableViewCell.self))
        tableView.register(UserReviewTableViewCell.self, forCellReuseIdentifier: String(describing: UserReviewTableViewCell.self))
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: String(describing: LoadingTableViewCell.self))
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
        self.addSubview(reviewTableView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        reviewTableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
}
