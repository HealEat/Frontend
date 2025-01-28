// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import SnapKit

class MarketView: UIView {
    
    var pageViewControllers: [UIViewController] = []
    
    var expanded: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var navigationSafeAreaView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var navigationBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .label
        return button
    }()
    
    lazy var navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .healeatBlack
        label.alpha = 0
        return label
    }()
    
    lazy var expandableView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .healeatBlack
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8)
        label.textColor = .healeatGray5
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.tintColor = .healeatBlack
        return button
    }()
    
    lazy var mainRatingView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var ratingStarView: StarsView = {
        let starView = StarsView(accentColor: .healeatYellow, baseColor: UIColor(red: 184/255, green: 184/255, blue: 184/255, alpha: 1))
        return starView
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return label
    }()
    
    lazy var openView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var openLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .medium)
        return label
    }()
    
    lazy var openHourLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8)
        label.textColor = UIColor(red: 131/255, green: 131/255, blue: 131/255, alpha: 1)
        return label
    }()
    
    lazy var typeView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var typeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 20, height: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(TypeCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TypeCollectionViewCell.self))
        
        return collectionView
    }()
    
    lazy var detailRatingView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var detailRatingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 7
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 40, height: 35)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(DetailRatingCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: DetailRatingCollectionViewCell.self))
        
        return collectionView
    }()
    
    lazy var previewView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var previewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(PreviewCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PreviewCollectionViewCell.self))
        return collectionView
    }()
    
    lazy var expandableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 7
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    lazy var topTabBar: TabBarSegmentedControl = {
        let tabBarSegmentedControl = TabBarSegmentedControl(menus: [
            "홈",
            "사진",
            "리뷰",
        ])
        return tabBarSegmentedControl
    }()
    
    lazy var menuPageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        if let firstViewController = pageViewControllers.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        return pageViewController
    }()
    
    
    private func addComponents() {
        self.addSubview(expandableView)
        expandableView.addSubview(expandableStackView)
        expandableStackView.addArrangedSubview(titleView)
        expandableStackView.addArrangedSubview(mainRatingView)
        expandableStackView.addArrangedSubview(openView)
        expandableStackView.addArrangedSubview(typeView)
        expandableStackView.addArrangedSubview(detailRatingView)
        expandableStackView.addArrangedSubview(previewView)
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        titleView.addSubview(bookmarkButton)
        
        mainRatingView.addSubview(ratingStarView)
        mainRatingView.addSubview(ratingLabel)
        
        openView.addSubview(openLabel)
        openView.addSubview(openHourLabel)
        
        typeView.addSubview(typeCollectionView)
        
        detailRatingView.addSubview(detailRatingCollectionView)
        
        previewView.addSubview(previewCollectionView)
        
        self.addSubview(topTabBar)
        self.addSubview(menuPageViewController.view)
        
        self.addSubview(navigationView)
        navigationView.addSubview(navigationSafeAreaView)
        navigationSafeAreaView.addSubview(navigationBackButton)
        navigationSafeAreaView.addSubview(navigationTitleLabel)
        setConstraints()
    }
    private func setConstraints() {
        navigationView.snp.makeConstraints({ make in
            make.top.leading.trailing.equalToSuperview()
        })
        navigationSafeAreaView.snp.makeConstraints({ make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(40)
        })
        navigationBackButton.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(18)
        })
        navigationTitleLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(navigationBackButton.snp.trailing).offset(10)
        })
        expandableView.snp.makeConstraints({ make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        })
        expandableStackView.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(7)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
        })
        titleLabel.snp.makeConstraints({ make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        })
        subtitleLabel.snp.makeConstraints({ make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(6)
            make.bottom.equalToSuperview()
        })
        bookmarkButton.snp.makeConstraints({ make in
            make.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(14)
        })
        ratingStarView.snp.makeConstraints({ make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        })
        ratingLabel.snp.makeConstraints({ make in
            make.leading.equalTo(ratingStarView.snp.trailing).offset(6)
            make.top.bottom.equalToSuperview()
        })
        openLabel.snp.makeConstraints({ make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        })
        openHourLabel.snp.makeConstraints({ make in
            make.leading.equalTo(openLabel.snp.trailing).offset(3)
            make.top.bottom.equalToSuperview()
        })
        typeCollectionView.snp.makeConstraints({ make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(20)
        })
        detailRatingCollectionView.snp.makeConstraints({ make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(35)
        })
        previewCollectionView.snp.makeConstraints({ make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(120)
        })
        topTabBar.snp.makeConstraints({ make in
            make.top.equalTo(expandableView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35)
        })
        menuPageViewController.view.snp.makeConstraints({ make in
            make.top.equalTo(topTabBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        })
    }
    
    func updateExpandableAreaView(height: CGFloat) {
        let correctedHeight = min(max(0, height), expandableView.frame.height)
        
        expandableView.snp.remakeConstraints({ make in
            make.top.equalTo(navigationView.snp.bottom).offset(correctedHeight - expandableView.frame.height)
            make.leading.trailing.equalToSuperview()
        })
    }
}
