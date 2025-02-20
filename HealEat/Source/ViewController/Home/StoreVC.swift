// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then
import SnapKit

protocol StoreVCDelegate: AnyObject {
    func didTapHealthSetting()
    func didFetchStoreData(storeData: [StoreResponse])
}

class StoreVC: UIViewController {
    weak var delegate: StoreVCDelegate?
    private var storeData: [StoreResponse] = []
    public let storeview = StoreView()
    public let loginVC = LoginVC()
    public var isloggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn")
    public var hasHealthInfo: Bool = false
    public let notloginview = NotloginView()
    public let healthsettingview = HealthInfoSettingView()
    public let purposevc = PurposeVC()
    private var isFetchingData = false
    var currentPage = 1
    var isLastPage = false
    private var currentLatitude: Double = 37.550874837441
    private var currentLongitude: Double = 126.925554591431
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isloggedIn {
            self.view = notloginview
            notloginview.gotologinButton.addTarget(self, action: #selector(gotologinTapped), for: .touchUpInside)
        }
        else {
            if !hasHealthInfo {
                self.view = storeview
                storeview.isUserInteractionEnabled = true // 이벤트 활성화
                storeview.storeCollectionView.isUserInteractionEnabled = true
                setupCollectionView()
                storeview.healthsettingButton.addTarget(self, action: #selector(healthsettingTapped), for: .touchUpInside)
            }
            else {
                self.view = healthsettingview
                healthsettingview.healthsettingButton.addTarget(self, action: #selector(gotohealthsetting), for: .touchUpInside)
            }
        }
    }
    
    
    func updateLocation(lat: Double, lon: Double) {
        self.currentLatitude = lat
        self.currentLongitude = lon
        fetchStoreData()
    }
    
    private func fetchStoreData() {
        guard !isLastPage, !isFetchingData else { return }
        
        isFetchingData = true

        APIManager.HomeProvider.request(.getStores(lon: currentLongitude, lat: currentLatitude, radius: 1000, page: currentPage)) { result in
            self.isFetchingData = false

            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(DefaultResponse<HomeResponse>.self, from: response.data)
                    print("받아온 데이터: \(decodedData)")
                    
                    let memberName = decodedData.result?.searchInfo?.memberName ?? "힐릿"
                    DispatchQueue.main.async {
                        self.storeview.setUserRecommendLabel(name: memberName)
                    }
                    
                    if let storeList = decodedData.result?.storeList {
                        
                        self.storeData.append(contentsOf: storeList) // 기존 데이터에 추가
                        self.isLastPage = decodedData.result?.isLast ?? false
                        self.currentPage += 1
                        
                        DispatchQueue.main.async {
                            self.storeview.storeCollectionView.reloadData()
                            print("📌 StoreVC -> didFetchStoreData 호출")
                            self.delegate?.didFetchStoreData(storeData: self.storeData)
                        }
                        
                        // 다음 페이지가 있으면 추가 요청
                        if !self.isLastPage {
                            self.fetchStoreData()
                        }
                    }
                } catch {
                    print("❌ JSON 디코딩 오류:", error)
                }
            case .failure(let error):
                print("❌ API 요청 실패:", error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func setupCollectionView() {
        storeview.storeCollectionView.dataSource = self
        storeview.storeCollectionView.delegate = self
        storeview.storeCollectionView.bounces = false
        storeview.storeCollectionView.contentInsetAdjustmentBehavior = .never
        storeview.storeCollectionView.isScrollEnabled = true
        storeview.storeCollectionView.canCancelContentTouches = false
        
        storeview.storeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 55, right: 0)
    }

    public func reloadCollectionView() {
        
        self.storeview.storeCollectionView.reloadData()
        self.storeview.storeCollectionView.collectionViewLayout.invalidateLayout()
        self.storeview.storeCollectionView.layoutIfNeeded()
        
    }
    
    @objc private func healthsettingTapped() {
        delegate?.didTapHealthSetting() //HomeVC에 버튼 클릭 이벤트 전달
    }
    
    @objc private func gotologinTapped() {
        guard presentedViewController == nil else { return }
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc private func gotohealthsetting() {
        purposevc.modalPresentationStyle = .fullScreen
        present(purposevc, animated: true, completion: nil)
    }
}

extension StoreVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell( withReuseIdentifier: StoreCollectionViewCell.identifier, for: indexPath) as? StoreCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        let model = storeData[indexPath.row]
        cell.storeconfigure(model: model)

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let marketVC = MarketVC()
       marketVC.param = MarketVC.Param(placeId: storeData[indexPath.row].id)
       navigationController?.pushViewController(marketVC, animated: true)
        let marketVC = MarketVC()
        marketVC.param = MarketVC.Param(placeId: storeData[indexPath.row].id)
        let nav = UINavigationController(rootViewController: marketVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
//        navigationController?.pushViewController(marketVC, animated: true)
    }
}
