// Copyright © 2025 HealEat. All rights reserved.

import UIKit
import Then
import SnapKit

protocol StoreVCDelegate: AnyObject {
    func didTapHealthSetting()
}

class StoreVC: UIViewController {
    weak var delegate: StoreVCDelegate?
    private var storeData: [StoreResponse] = []
    public let storeview = StoreView()
    public let loginVC = LoginVC()
    public var isloggedIn: Bool = true
    public var hasHealthInfo: Bool = false
    public let notloginview = NotloginView()
    public let healthsettingview = HealthInfoSettingView()
    public let purposevc = PurposeVC()
    private var isFetchingData = false
    var currentPage = 1
    var isLastPage = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isloggedIn {
            self.view = notloginview
            notloginview.gotologinButton.addTarget(self, action: #selector(gotologinTapped), for: .touchUpInside)
        }
        else {
            if !hasHealthInfo {
                self.view = storeview
                setupCollectionView()
                storeview.healthsettingButton.addTarget(self, action: #selector(healthsettingTapped), for: .touchUpInside)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.reloadCollectionView()
                }
                fetchStoreData()
            }
            else {
                self.view = healthsettingview
                healthsettingview.healthsettingButton.addTarget(self, action: #selector(gotohealthsetting), for: .touchUpInside)
            }
        }
    }
    
    private func fetchStoreData() {
        guard !isLastPage else { return }
        isFetchingData = true // API 호출 시작

        APIManager.HomeProvider.request(.getStores(lat: 37.5665, lon: 126.978, radius: 1000, page: currentPage)) { result in
            self.isFetchingData = false // API 응답 후 다시 API 요청 가능하게 변경

            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(DefaultResponse<HomeResponse>.self, from: response.data)
                        
                    if let memberName = decodedData.result?.searchInfo.memberName, !memberName.isEmpty {
                        DispatchQueue.main.async {
                            self.storeview.setUserRecommendLabel(name: memberName)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.storeview.setUserRecommendLabel(name: "힐릿")
                        }
                    }
                
                    
                    if let storeList = decodedData.result?.storeList {
                        self.storeData.append(contentsOf: storeList) // 기존 데이터에 추가
                        self.currentPage += 1
                        self.isLastPage = decodedData.result?.isLast ?? false
                        
                        DispatchQueue.main.async {
                            
                            self.reloadCollectionView()
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
        reloadCollectionView()
    }

    private func setupCollectionView() {
        storeview.storeCollectionView.dataSource = self
        storeview.storeCollectionView.delegate = self
        storeview.storeCollectionView.bounces = false
        storeview.storeCollectionView.contentInsetAdjustmentBehavior = .never
        storeview.storeCollectionView.reloadData()
    }

    public func reloadCollectionView() {
        DispatchQueue.main.async {
            self.storeview.storeCollectionView.reloadData()
            self.storeview.updateCollectionViewHeight()
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 2, !isFetchingData {
            isFetchingData = true
            fetchStoreData()
        }
    }
}
